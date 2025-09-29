# pylint: disable = http-used,print-used,no-self-use

import datetime
import operator
from typing import Annotated, TypedDict

from dotenv import load_dotenv
from langchain_core.messages import AnyMessage, HumanMessage, SystemMessage, ToolMessage
from langchain_google_genai import ChatGoogleGenerativeAI
from langgraph.checkpoint.memory import MemorySaver
from langgraph.graph import END, StateGraph

from agents.tools.flights_finder import flights_finder
from agents.tools.hotels_finder import hotels_finder

_ = load_dotenv()

CURRENT_YEAR = datetime.datetime.now().year


class AgentState(TypedDict):
    messages: Annotated[list[AnyMessage], operator.add]


TOOLS_SYSTEM_PROMPT = f"""You are a smart travel agency. Use the tools to look up information.
    You are allowed to make multiple calls (either together or in sequence).
    Only look up information when you are sure of what you want.
    The current year is {CURRENT_YEAR}.
    If you need to look up some information before asking a follow up question, you are allowed to do that!
    I want to have in your output links to hotels websites and flights websites (if possible).
    I want to have as well the logo of the hotel and the logo of the airline company (if possible).
    In your output always include the price of the flight and the price of the hotel and the currency as well (if possible).
    for example for hotels-
    Rate: $581 per night
    Total: $3,488
    """

TOOLS = [flights_finder, hotels_finder]


class TravelAgent:
    def __init__(self):
        self._tools = {t.name: t for t in TOOLS}
        self._tools_llm = ChatGoogleGenerativeAI(
            model="gemini-2.0-flash",
            temperature=0.1
        ).bind_tools(TOOLS)

    @staticmethod
    def exists_action(state: AgentState):
        result = state['messages'][-1]
        if len(result.tool_calls) == 0:
            return END
        return 'invoke_tools'

    def call_tools_llm(self, state: AgentState):
        messages = state['messages']
        messages = [SystemMessage(content=TOOLS_SYSTEM_PROMPT)] + messages
        message = self._tools_llm.invoke(messages)
        return {'messages': [message]}

    def invoke_tools(self, state: AgentState):
        tool_calls = state['messages'][-1].tool_calls
        results = []
        for t in tool_calls:
            print(f'Calling: {t}')
            if not t['name'] in self._tools:  # check for bad tool name from LLM
                print('\n ....bad tool name....')
                result = 'bad tool name, retry'  # instruct LLM to retry if bad
            else:
                result = self._tools[t['name']].invoke(t['args'])
            results.append(ToolMessage(tool_call_id=t['id'], name=t['name'], content=str(result)))
        print('Back to the model!')
        return {'messages': results}


# Create the graph
def create_graph():
    agent = TravelAgent()
    
    builder = StateGraph(AgentState)
    builder.add_node('call_tools_llm', agent.call_tools_llm)
    builder.add_node('invoke_tools', agent.invoke_tools)
    builder.set_entry_point('call_tools_llm')

    builder.add_conditional_edges('call_tools_llm', TravelAgent.exists_action, {'invoke_tools': 'invoke_tools', END: END})
    builder.add_edge('invoke_tools', 'call_tools_llm')
    
    memory = MemorySaver()
    return builder.compile(checkpointer=memory)


# This is the graph that LangGraph CLI will use
graph = create_graph()

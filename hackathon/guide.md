# IBM Dev Day AI Demystified Hackathon
## Hackathon Guide

---

## IBM Dev Day AI Demystified Hackathon

AI agents are intelligent systems that can perceive their environment, reason about it, and take actions to achieve specific goals. These agents can operate autonomously or collaboratively, making them ideal for solving complex real-world problems.

In this hackathon, you will design and build a proof-of-concept agentic AI solution using **IBM watsonx Orchestrate** – a no-code and low-code platform designed to orchestrate AI agents across business workflows. With watsonx Orchestrate, you can create, deploy, and manage intelligent agents and assistants that automate tasks, streamline processes, and enhance productivity.

This guide explains how to access your IBM Cloud environment, use watsonx Orchestrate, and build a proof-of-concept agentic solution for the hackathon.

---

## Contents

- [The hackathon expectation](#the-hackathon-expectation)
  - [A note on using other technologies](#a-note-on-using-other-technologies)
  - [A note on data sets before you begin](#a-note-on-data-sets-before-you-begin)
- [Get started with IBM watsonx](#get-started-with-ibm-watsonx)
  - [Note on available services](#note-on-available-services)
  - [Note on preventing exposure of IBM Cloud credentials](#note-on-preventing-exposure-of-ibm-cloud-credentials)
  - [Note on IBM cloud service usage](#note-on-ibm-cloud-service-usage)
  - [Accessing your hackathon IBM Cloud account](#accessing-your-hackathon-ibm-cloud-account)
  - [Accessing and utilizing IBM watsonx products](#accessing-and-utilizing-ibm-watsonx-products)
- [1. IBM watsonx Orchestrate](#1-ibm-watsonx-orchestrate)
  - [Accessing watsonx Orchestrate](#accessing-watsonx-orchestrate)
  - [Discover the catalog](#discover-the-catalog)
  - [Building agents](#building-agents)
  - [Using agents in the chat](#using-agents-in-the-chat)
  - [Managing app connections](#managing-app-connections)
  - [watsonx Orchestrate API](#watsonx-orchestrate-api)
  - [Building AI assistants](#building-ai-assistants)
  - [Quick start hands-on exercises](#quick-start-hands-on-exercises)
- [2. IBM watsonx.ai (OPTIONAL)](#2-ibm-watsonxai-optional)
  - [Note on IBM watsonx.ai service usage](#note-on-ibm-watsonxai-service-usage)
  - [Note on available watsonx.ai capabilities](#note-on-available-watsonxai-capabilities)
  - [Access Prompt Lab on watsonx.ai](#access-prompt-lab-on-watsonxai)
  - [Work with the watsonx.ai Prompt Lab](#work-with-the-watsonxai-prompt-lab)
  - [Prompt Lab editor](#prompt-lab-editor)
  - [Selecting an AI model](#selecting-an-ai-model)
  - [Programmatic access (API/SDK)](#programmatic-access-apisdk)
  - [watsonx.ai AI agent libraries and tutorials](#watsonxai-ai-agent-libraries-and-tutorials)
  - [Quick start hands-on exercises](#quick-start-hands-on-exercises-1)
  - [Save your Prompt Lab session](#save-your-prompt-lab-session)
  - [Save your work on watsonx.ai](#save-your-work-on-watsonxai)
- [Appendix: Example use cases](#appendix-example-use-cases)

---

## The hackathon expectation

In this hackathon, you will design and build a proof-of-concept agentic AI solution using IBM watsonx Orchestrate, a low-code platform to build and deploy AI agents for the following theme:

**AI Demystified — From idea to deployment**

Every great idea deserves a faster path to reality. Use AI to simplify the steps that slow teams down — organizing work, connecting tools, or turning insights into action. Show how approachable, practical AI can make building and launching new solutions easier for everyone.

Refer to [example use cases](#appendix-example-use-cases) to help you brainstorm ideas for building a solution.

Participants may also optionally use the below listed watsonx product:

- **IBM watsonx.ai** is a powerful AI studio that supports the development of agentic AI solutions using a wide range of foundation models. Through the Prompt Lab, participants can experiment with IBM's Granite models and other leading models to create agents that understand and respond to natural language. IBM watsonx.ai can also serve as an inference provider for your agents, allowing them to generate responses, make decisions, and interact with users or systems intelligently.

### A note on using other technologies

You may use any framework or technology to build your solution as long as you adhere to all product usage policies. However, to be eligible for judging, your solution must showcase IBM watsonx Orchestrate as a core component.

### A note on data sets before you begin

Participants are required to bring their own datasets to build the solution aligning to your use case. As you collect data for your project, you'll want to use best practices. Here are helpful tips:

- Teams are responsible for ensuring data is compliant.
- Data from public websites may be used, if the terms allow for commercial use, but please keep a list of the websites you use.
- Do not use data or assets containing company confidential data, or any other data without permission from the data owner. Teams are responsible for getting approval.
- Do not use any client data.
- Do not use any data containing personal information (PI).
- Do not use data obtained from social media.

---

## Get started with IBM watsonx

To access and use IBM watsonx products for this hackathon, participants must be registered for the hackathon, and have access to the hackathon site. Once you have access to the hackathon site, follow the instructions on the "Complete the hackathon" page to request a pre-configured IBM Cloud account for your team. This account will provide the necessary environment to work with the supporting IBM products for this hackathon.

### Note on available services

The IBM Cloud account provisioned for this hackathon is pre-configured with only the services required to complete the hackathon. You will not be able to configure any new service or modify permissions for existing ones due to restricted access. If you notice a permission/access issue for any service or the cloud catalog, then they are not required/available for this hackathon.

The following optional IBM Cloud services are provided for your hackathon solution building:

- Code Engine
- Natural Language Understanding
- Speech-to-Text
- Text-to-Speech
- Cloudant

### Note on preventing exposure of IBM Cloud credentials

Hackathon participants may use IBM Cloud credentials to build their solutions that leverage IBM technologies on IBM Cloud. During development, testing, collaboration, or while submitting their final project in a public repository, participants may unintentionally expose these credentials on publicly accessible platforms.

Exposing IBM Cloud API keys or any cloud credentials can lead to unauthorized access, misuse of resources, and account suspension. If any IBM Cloud credential associated with your hackathon account is detected in a public repository or publicly accessible platform:

- The credential will be deactivated immediately.
- Your hackathon cloud account access will be suspended until you:
  1. Remove the exposed credential from all public sources. If you are using GitHub, you can refer to [Removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository).
  2. Rotate and replace the exposed credential.
  3. After completing these steps, confirm remediation with the hackathon support team and request access to your hackathon cloud account.

Please follow the Preventing exposure of IBM Cloud credentials in public repositories and platforms guide for best practices to avoid disruptions to your project and ensure the security of your IBM Cloud resources.

### Note on IBM cloud service usage

For this hackathon, $100 credits will be automatically applied to your provisioned IBM Cloud account. These credits should be sufficient for designing and creating compelling submissions using the services available on your account.

You will receive periodic email notifications about your credit consumption at the following usage levels: 25%, 50%, and 80%. Once you reach 100% usage, your account will be suspended. You can appeal the suspension by completing the form shared in the account suspension notification email.

Please note that these email notifications are sent once per hour, so there is a possibility that you may exhaust all your credits before receiving an alert.

We recommend planning your usage carefully and backing up your work regularly to avoid disruptions.

### Accessing your hackathon IBM Cloud account

Once your team has been provisioned an IBM Cloud account, all team members will receive an email invite to join the hackathon provisioned cloud account. Follow the steps below to access your team's cloud account:

1. Check the email inbox you used to register for the hackathon and open the email you received from the IBM Cloud team about joining your cloud account. Please check your junk/spam folders if you are not able to find the email in your inbox. You can also quickly search for "IBM Cloud" to locate the email.

2. Click the **Join Now** button seen in that email. A new browser tab will open with the cloud account sign up page.

3. Review your account and personal information. Read and accept the Account notice and click the **Join Account** button.

4. Complete the authentication process by clicking the **Continue** button.

5. After you authenticate successfully, you will be taken to the IBM Cloud dashboard.

6. If you have an existing personal IBM Cloud account for the same email/IBMid, sometimes you will be directed to your personal account. In this case, please switch your account to the **xxxxxxx - watsonx** account. Select your account drop-down at top-right of the dashboard and select watsonx account. Refer to the below image on switching accounts in your cloud dashboard.

### Accessing and utilizing IBM watsonx products

To begin building your solution, explore the capabilities and resources for each IBM watsonx product enabled for this hackathon. Note, watsonx Orchestrate is a required product in this hackathon and any other product (watsonx.ai) are optional.

**1. IBM watsonx Orchestrate**

IBM watsonx Orchestrate is an intuitive, AI-powered platform that you can use to create, configure, and deploy intelligent agents that can automate business tasks. Whether you're automating repetitive workflows or building complex multi-agent systems, the platform is designed to support users of all skill levels.

**2. IBM watsonx.ai (Optional)**

A powerful AI studio that enables you to experiment with foundation models like IBM Granite through the Prompt Lab. It can be used to enhance your agents with natural language understanding, intelligent decision-making, and dynamic response generation—serving as an inference engine to make your AI agents smarter and more interactive.

---

## 1. IBM watsonx Orchestrate

After successfully joining the IBM Cloud account, you can access watsonx Orchestrate to begin working on the platform and building your solution.

With watsonx Orchestrate, you can:

- Build and deploy agents
- Automate tasks such as scheduling, data entry, and approvals
- Start small and scale up with advanced tools and integrations
- Explore the clean, guided UI that simplifies agent creation and management

Explore a few demos on how to use watsonx Orchestrate.

### Accessing watsonx Orchestrate

1. In your IBM Cloud account dashboard, select the **Navigation menu** on the top left of the dashboard and select the **Resource list** option.

2. Expand the **AI / Machine Learning** section and select **watsonx-Hackathon Orchestrate** service.

3. You will be navigated to watsonx-Hackathon Orchestrate service instance dashboard. Select the **Launch watsonx Orchestrate** button.

4. You will be navigated to the watsonx Orchestrate platform with a welcome message and a new chat window.

### Discover the catalog

The IBM watsonx Orchestrate catalog is your gateway to a rich collection of prebuilt AI agents and tools, designed to support a wide range of business functions and use cases. Whether you're looking to automate tasks, enhance productivity, or integrate with backend systems, the catalog helps you find the right solutions quickly and efficiently. Learn more about discovering the catalog.

### Building agents

In IBM watsonx Orchestrate, agents are a key component of the agentic AI framework, enabling you to create complex, dynamic systems that can adapt and respond to changing conditions.

By building agents, you can:

- Automate repetitive tasks
- Improve decision-making processes
- Enhance customer and employee experiences
- Increase operational efficiency

#### 1. Prepare to build AI agents

Developing intelligent, scalable, and reliable agents in watsonx Orchestrate requires a strategic, multi-phase approach. It goes beyond writing prompts or connecting APIs. Successful agents need thoughtful planning, structured development, testing, and ongoing governance. The following overview breaks down each phase of agent development, highlighting key considerations. Learn more about preparing to build AI agents.

#### 2. Creating and customizing agents

Creating and customizing an AI agent involves defining its purpose and personality through thoughtful descriptions and selecting the most suitable foundation model that aligns with your brand or use case. You can also configure key elements like the welcome message and starter prompts to ensure the agent engages users effectively from the first interaction. Together, the configured components shape how the agent communicates, responds, and delivers value across conversations.

Learn how to create an agent from scratch or from a template.

**Expanding your agent's capabilities:**

To enhance your agent's abilities, explore the following configuration options:

- **Define a profile**  
  Provide a clear and specific description of the agent's purpose. This helps in multi-agent orchestration by enabling accurate selection based on capabilities. See Defining the description of your agent.

- **Choose an AI model**  
  Choosing the right AI model helps your agent understand user intent, reason through tasks, and generate reliable responses. Your choice directly affects accuracy, performance, and cost. See Choosing an AI model.

- **Customize the welcome message and starter prompts**  
  Customize the welcome message and starter prompts to guide users when they begin interacting with the agent. See Customizing the welcome message and starter prompts.

- **Add knowledge**  
  Enhance the agent's domain expertise by adding contextual knowledge from files or content repositories. See Adding knowledge to agents.

- **Add and manage tools**  
  Integrate tools to enable the agent to perform automated tasks such as retrieving data or sending emails. See Adding and managing tools for agents.

- **Orchestrate agents**  
  Enable multi-agent orchestration by adding collaborator agents that work together to achieve shared goals. See Orchestrating agents.

- **Add instructions**  
  AI agents operate based on a set of behavioral instructions that define how they respond to user inputs, perform tasks, and interact across different channels. These instructions serve as the agent's internal guidelines, helping it act consistently and effectively in various scenarios. See Adding instructions to agents.

- **Connect agents to channels**  
  Channels are the interfaces through which you can interact with a conversational agent, such as messaging platforms and voice assistants. Integrate your agent with these channels to access services and support directly within your preferred environments to enable seamless and scalable communication. See Connecting agents to channels.

- **Configure rich responses**  
  Enable rich responses to incorporate multimedia and structured elements, making AI interactions clearer, more efficient, and engaging for users. See Configuring rich responses from the AI assistant builder.

- **Deploy agents**  
  Finalize the setup by deploying the agent to make it available in live environments such as chat interfaces. See Deploying agents.

- **Embed agents in applications**  
  IBM watsonx Orchestrate makes it easy to embed intelligent agents directly into your web applications by using the embedded chat feature. It enables interactive, contextual conversations while maintaining enterprise-grade security and flexibility. See Embedding agents in applications.

- **Building agents using the ADK**  
  You can build powerful, customizable agents using the IBM watsonx Orchestrate Agent Development Kit (ADK). Learn more about using the ADK.

#### 3. Building tools

Tools act as interfaces to external capabilities, enabling agents to interact with systems, retrieve data, run calculations, or trigger workflows that go beyond their built-in reasoning. You can build new tools and edit existing tools for your agents to use.

Following are the different ways to add a tool:

- Creating agentic workflows
- Adding tools to an agent
  - Catalog
  - Local instance
- Importing external tools
  - MCP server
  - OpenAPI

### Using agents in the chat

In IBM watsonx Orchestrate, agents collaborate to automate tasks and manage workflows. Learn more using agents in Orchestrate Chat.

### Managing app connections

To use the external applications within IBM watsonx Orchestrate, you must establish a connection between them which acts as bridge enabling communication between watsonx Orchestrate and the external applications. Learn more about managing app connections and credentials.

### watsonx Orchestrate API

IBM watsonx Orchestrate provides a set of APIs to boost your experience using the features from the product.

- **Getting started with the API**  
  Begin using the API with practical, step-by-step guidance.

- **API reference**  
  Get the methods that you can use to call custom projects, or other resources from the AI chat.

### Building AI assistants

In IBM watsonx Orchestrate, you build the AI assistant by using AI assistant builder. AI assistant builder is a chat interface builder that helps to deploy an engaging and embedded chatbot experience. AI assistant builder integrates the power of large language models (LLMs) and conversational capabilities of watsonx Assistant to enable responsive and interactive conversation between the users and watsonx Orchestrate.

To learn more, see Building AI assistants in AI assistant builder.

### Quick start hands-on exercises

Try the quick start hands-on exercises for sample use cases to get started with using watsonx Orchestrate:

**Important notes:**

- You must use the hackathon provisioned IBM cloud account to access and use watsonx Orchestrate platform to try the below sample exercises.

**watsonx Orchestrate SaaS sample exercises:**

- **Develop agents with no code using watsonx Orchestrate**  
  A hands-on guide for developing a multi-agent system in watsonx Orchestrate with no code that can communicate with the agents on various channels.

- **Creating intelligent, reusable agentic workflows on watsonx Orchestrate with no code**  
  A hands-on guide for creating AI-driven, human-in-the-loop workflows without writing code.

- **Build context-aware AI agents with watsonx Orchestrate and Astra DB**  
  AI agents are only as effective as their data, making precise retrieval essential for reliable results.

- **AgentOps in watsonx Orchestrate: Observability for Agents with Langfuse and IBM Telemetry**  
  A developer's guide for instrumenting and observing Agents with Langfuse and IBM Telemetry in watsonx Orchestrate.

- **Building and deploying prebuilt domain agents in watsonx Orchestrate**  
  Explore how to work with the prebuilt domain agents and integrate them into existing workflows.

- **Build a scheduled agentic workflow for daily notifications**  
  A practical example of building, importing, and scheduling an agentic workflow that automatically sends daily email notifications using watsonx Orchestrate.

- **Multi-agent orchestration with watsonx Orchestrate**  
  A hands-on journey to design, extend, and integrate AI agents by using Langflow, IBM Granite models, Astra DB, the AI Gateway, and a custom user interface on watsonx Orchestrate.

**watsonx Orchestrate Agent Development Kit (ADK) sample exercises:**

- **Getting Started with watsonx Orchestrate Agent Development Kit**  
  IBM watsonx Orchestrate includes the Agent Development Kit (ADK) which is a set of developer-focused tools for building, testing, and managing agents. With the ADK, developers get the freedom and control to design powerful agents using a lightweight framework and a simple CLI. You can define agents in clear YAML or JSON files, create custom Python tools, and manage the entire agent lifecycle with just a few commands.

- **Build an AI agent with Langflow, Granite 4.0 models, and watsonx Orchestrate**  
  A hands-on guide for creating Langflow tools, consuming them with watsonx Orchestrate Agent Development Kit, and using IBM Granite 4.0 Micro model for inference.

- **Connecting to MCP tools with watsonx Orchestrate**  
  A hands-on guide for creating MCP tools and consuming them with watsonx Orchestrate Agent Development Kit.

- **Extend Your AI Agents with External LLMs Using watsonx Orchestrate and AI Gateway**  
  A hands-on guide to bring your own model (BYOM) into watsonx Orchestrate using AI Gateway.

- **Create consistent evaluation workflows for AI agents**  
  A hands-on guide to setup and use a structured evaluation strategy to test, benchmark, and improve AI agent performance.

---

## 2. IBM watsonx.ai (OPTIONAL)

After successfully joining the IBM Cloud account, you can access watsonx.ai to begin working on the platform and building your solution.

### Note on IBM watsonx.ai service usage

For this hackathon, $100 credits will be automatically applied for the IBM services provisioned on the cloud account. This should be sufficient for designing and creating compelling submissions.

You will receive periodic email notifications about your credit consumption at the following usage levels: 25%, 50%, and 80%. Once you reach 100% usage, your account will be suspended. You can appeal the suspension by completing the form shared in the account suspension notification email.

Please note that these email notifications are sent once per hour, so there is a possibility that you may exhaust all your credits before receiving an alert.

IBM watsonx.ai service consumes the credits when used. Please plan to use it efficiently and back up your work accordingly. Refer tips to work efficiently on watsonx.ai platform (Tokens and CUH explained) and saving your work.

**Important:**

- Foundation model inferencing consumes tokens, which are measured as Resource Units (RUs).  
  1,000 tokens = 1 RU, and each RU costs $0.0001 USD.  
  Learn more about tokens and tokenization.

- If you are using Jupyter Notebook editor on watsonx.ai, consider selecting a lower runtime environment to avoid high resource consumption and quickly depleting your credits. Notebook runtimes are billed based on Capacity Unit Hours (CUH) at a rate of $1.02 USD per CUH.  
  Learn more about capacity unit hours and watsonx.ai Studio pricing plans.

### Note on available watsonx.ai capabilities

The watsonx.ai platform is pre-configured with only the services required to complete the hackathon. If you notice a permission/access issue for any service or the cloud catalog, then they are not required/available for this hackathon.

These features/capabilities are out of scope for this hackathon:

- Agent Lab (Beta)
- Bring your own model
- Fine tuning models
- AutoAI pipeline
- AI governance
- Evaluation Studio
- SPSS Modeler

**DO NOT USE** the below listed watsonx.ai models as they are out of scope for the hackathon and can negatively impact the judgment of your project submission.

- llama-3-405b-instruct
- mistral-medium-2505
- mistral-small-3-1-24b-instruct-2503

The hackathon provisioned IBM Cloud account will be deactivated after the completion of the hackathon. Please plan to save your work at the end of the hackathon.

### Access Prompt Lab on watsonx.ai

After successfully joining the IBM Cloud account, you can now access the Prompt Lab on watsonx.ai platform to work with the AI models supported on the platform and build your solution.

1. Log in to the watsonx.ai platform with the email you used to access your IBM Cloud account.

2. After successful authentication, you will see "Welcome to watsonx" widget. You can either take the tour or skip it.

3. Next, you will see the watsonx.ai dashboard. Ensure the name of the account is "xxxxxxx – watsonx" and the region is "Dallas".

4. Select the **Open Prompt Lab** button on the "Chat and build prompts with foundational models" widget.

5. The "Welcome to Prompt Lab" tour will be displayed. You can take the tour to get a quick introduction or skip it.

6. The Prompt Lab Editor opens with a chat window to get you started with the prompt session.

### Work with the watsonx.ai Prompt Lab

The watsonx.ai Prompt Lab is an easy-to-use prompt engineering interface where you can experiment with prompting different AI foundation models, explore sample prompts, tune model parameters, integrate applications with an API endpoint, and save and share your best prompts.

Take a tour of the Prompt Lab and try the interactive demo.

You can access and use the AI models to build your innovative solution using Prompt Lab.

### Prompt Lab editor

In the Prompt Lab, you can experiment with prompting different foundation models, explore sample prompts, as well as save and share your best prompts. The Prompt Lab editor is a great place to experiment and iterate with your prompts. Try the quick start lab.

However, you can also prompt foundation models in watsonx.ai programmatically. Refer to "Programmatic access (API/SDK)" section.

### Selecting an AI model

A default AI model will be pre-selected in the Prompt Lab editor. You can either use the same model or change to a different model. To select a different model:

1. Select the **AI Model** drop-down menu at the top-right of the editor and select **View all foundation models**.

2. A foundation model selection widget appears. Clear the filters to see all the available models. You can use the filters to choose the right model for your solution building. You can select a model tile to learn about the model and use it. If you are limited to only "Chat" supported models, change the Prompt Lab editor to Structured or Freeform view and try selecting the models to see all the available model options.

**Important:** DO NOT USE the below listed watsonx.ai models as they are out of scope for the hackathon and can negatively impact the judgment of your project submission.

- llama-3-405b-instruct
- mistral-medium-2502
- mistral-small-3-1-24b-instruct-2503

To understand how models can address your use case, including information on model modalities, supported languages, tuning, and indemnification, see our product documentation on choosing a model.

**Note:** Bigger models are not always better. Learn why smaller models can be better and more cost effective.

### Programmatic access (API/SDK)

You can inference the watsonx.ai models with API or SDK requests.

#### Developer access information

To use the supported watsonx.ai APIs/SDKs, you will need three values: a project ID, an endpoint URL and an API key.

- Go to watsonx.ai home page.
- Scroll down to the "Developer access" section.
- Select the **Project or deployment space** drop-down and choose the **watsonx Hackathon Sandbox** option if you are working with that project, or select any other listed project that you are working with. A project ID will be displayed.
- A default watsonx.ai endpoint URL will be displayed for the Dallas region. Ensure the region is always set to Dallas at the top right of the watsonx.ai home page.
- Select the **Create API key** button. A Create API key widget will be displayed. Enter a name, provide optional description and choose the "Disable the leaked key" option. Click the **Create** button.
- An API key will be created successfully. Copy the API key and save it safely to use for calling the API/SDK. You can also download and save the file in a secure path in your system.

#### watsonx.ai programmatic options

There are multiple options to help you get started using watsonx.ai APIs/SDKs.

**Option 1: Prompt Code on Prompt Lab**

Refer to the access prompt code instructions to learn how to quickly get access to the text generation API within the watsonx.ai Prompt Lab.

**Option 2: Different watsonx.ai API capabilities**

Explore and leverage different watsonx.ai API capabilities in your solution.

- Chat
- Agent-driven chat
- Tool calling
- Text generation
- Time series
- Text rerank
- Embeddings
- Text extraction

Refer to supported API functionality by AI model here.

#### Access the prompt code (API) from Prompt Lab editor

To prompt an AI model programmatically, you can view and copy the prompt code by selecting the **View code** icon `</>` at the top-right of the prompt lab editor.

The prompt code is available as a Curl, Node.js and Python.

You will require an IAM access token to authorize the prompt code and need to replace `${YOUR_ACCESS_TOKEN}` placeholder in the prompt code. You can create an IAM access token using an API key.

**API key:**

Refer to Developer access information to get an API key.

**Generate IAM Access Token:**

Programmatically generate an IAM access token with the API key using the following cURL command:

```bash
curl -X POST 'https://iam.cloud.ibm.com/identity/token' -H 'Content-Type: application/x-www-form-urlencoded' -d 'grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=MY_APIKEY'
```

- `curl -X POST` → Specifies an HTTP POST request.
- URL (`"https://iam.cloud.ibm.com/identity/token"`) → The endpoint to request an authentication token from IBM Cloud.
- `-H "Content-Type: application/x-www-form-urlencoded"` → Sets the request header to indicate that the data is sent in form-encoded format.
- `-d` (Data Payload) → Sends the required data:
  - `grant_type=urn:ibm:params:oauth:grant-type:apikey` → Specifies the OAuth grant type as API Key.
  - `apikey=MY_IBM_CLOUD_API_KEY` → Replace `MY_IBM_CLOUD_API_KEY` with your actual IBM Cloud API key.

**Expected Response:**

```json
{
  "access_token": "eyJhbGciOiJIUz......sgrKIi8hdFs",
  "refresh_token": "not_supported",
  "token_type": "Bearer",
  "expires_in": 3600,
  "expiration": 1473188353,
  "scope": "ibm openid"
}
```

**Note:** An IAM token is valid for up to 60 minutes, and it is subject to change. When a token expires, you must generate a new one. Use the property `"expires_in"` for the expiration of the IAM token that you have just created.

### watsonx.ai AI agent libraries and tutorials

Explore the watsonx.ai supported AI agent framework libraries and tutorials to help you get started building your AI agent solution.

- LangChain
- LangGraph
- LlamaIndex
- CrewAI
- BeeAI
- AutoGen
- Python SDK
- Node.js SDK

### Quick start hands-on exercises

Try the quick start exercises and notebooks for sample use cases to get started with using watsonx.ai.

**Important notes:**

- Refer to developer access information section to use watsonx.ai credentials as you try the exercises.
- Some of the exercises could include the usage of old model version. You can replace them with newer versions for better performance and output. To check the latest supported AI models on watsonx.ai, either follow selecting an AI model on Prompt Lab or refer to supported foundation models on watsonx.ai.
- The hackathon provisioned cloud accounts do not support solution deployment. You can run your solution deployment locally on your machine and showcase them in your submissions.
- Foundation model inferencing consumes tokens, which are measured as Resource Units (RUs).  
  1,000 tokens = 1 RU, and each RU costs $0.0001 USD.  
  Learn more about tokens and tokenization.
- If you are using Jupyter Notebook editor on watsonx.ai, consider selecting a lower runtime environment to avoid high resource consumption and quickly depleting your credits. Notebook runtimes are billed based on Capacity Unit Hours (CUH) at a rate of $1.02 USD per CUH.  
  Learn more about capacity unit hours and watsonx.ai Studio pricing plans.

**watsonx.ai Prompt Lab app templates:**

- LangGraph LLM app template with function calling capabilities (base template)
- LlamaIndex Workflow LLM app template with function calling capabilities (base template)
- CrewAI LLM app template with function calling capabilities (base template)
- arXiv Research agent (community template)
- Agentic RAG LangGraph template (community template)

**BeeAI Agent Framework:**

- BeeAI framework examples

**LangChain and LangGraph:**

- Create a LangChain AI Agent in Python using watsonx
- Build a RAG agent using LangGraph to answer complex questions
- Build a LangChain agentic RAG system using the Granite model in watsonx.ai
- Use watsonx, and LangChain Agents to perform sequence of actions
- Use watsonx, and LangChain to make a series of calls to a language model
- arXiv Research agent
- Base LangGraph LLM app template with function calling capabilities

**LlamaIndex:**

- Use watsonx and LlamaIndex for Text-to-SQL task
- Use watsonx, and `llama-3-1-70b-instruct` and LlamaIndex to make simple chat conversation and tool calls
- LlamaIndex Workflow LLM app template with function calling capabilities

**CrewAI:**

- Leveraging CrewAI and IBM watsonx
- Build an agentic framework with CrewAI memory, i18n, and IBM watsonx.ai
- Base CrewAI LLM app template with function calling capabilities

### Save your Prompt Lab session

You can save your Prompt Lab editor session for later use.

1. At the top of the Prompt Lab screen, select the **Save work** dropdown button and then select the **Save as** option.

2. A Save your work widget will appear. Select **Prompt session** under the Asset type option.

3. Enter a name and check the **View in project after saving** option under the Define details section.

4. Finally, click the **Save** button. Once you save, you will see the saved work under the **Assets** tab.

You can also save your work as:

- **Prompt template** to save only the current prompt without its history and selecting a Task suitable for your prompting.
- **Notebook** to continue prompting on a Jupyter Notebook environment. Prior knowledge of notebooks and Python programming language would be helpful to work with a Jupyter notebook. Read more about notebooks.

### Save your work on watsonx.ai

Make sure to save any work you want to retain for your records. IBM Cloud accounts will be deactivated at the end of the hackathon. Follow the steps below to save your work:

1. Go to your project's 'Overview' tab.
2. Select the 'Export or import project' drop down below the Bell icon in the top menu bar.
3. Click the 'Export project' option. This will open 'Export project to desktop' screen.
4. Select all the assets shown in your project (Work saved as Project session cannot be exported) and click 'Export' on the bottom-right of the screen.
5. The next screen will ask for confirmation that all sensitive information has been removed.
6. Click on 'Continue export'.
7. The download (zip) will be initiated, and the file will be saved on your computer.

---

## Appendix: Example use cases

You are not limited to these ideas, but here are a several examples for how you could apply IBM watsonx Orchestrate to solve a specific issue for this hackathon:

- **HR talent pipeline autopilot:** Create an agent that performs several key functions, including tracking hiring needs and screening applicants. It could also schedule interviews across calendars, draft feedback summaries, or update Applicant Tracking System (ATS) workflows end-to-end to remove coordination bottlenecks or accelerate hiring by automating repetitive steps.

- **Customer onboarding orchestrator:** Develop a solution where onboarding steps such as setting up legal documents, verifying identities, setting up training, or making Customer Relationship Management (CRM) updates, are automated by an agent that coordinates between legal, sales, training, and IT systems to cut onboarding time from days to minutes or eliminate manual process gaps.

- **IT asset lifecycle agent:** Create an agentic solution that tracks hardware/software assets, predicts renewal needs, files automated purchase or support requests, or updates Configuration Management Database (CMDB) records to reduce downtime risk or simplify IT operations.

- **AI procurement negotiation assistant:** Build an agent that analyzes supplier quotes, benchmarks market pricing, drafts negotiation messages, or updates procurement systems with recommended terms to shorten procurement cycles or improve cost efficiency.

- **Finance reconciliation and close assistant:** Explore how agentic AI could fetch data from Enterprise Resource Planning (ERP) systems, match transactions, highlight anomalies, draft reconciliation summaries, or update audit logs to speed up month-end close and reduce human error.

- **Contract compliance tracker:** Build an agent that can monitor contract obligations across departments, gather status updates, remind stakeholders, or produce compliance reports automatically to prevent missed deadlines or improve governance.

- **Intelligent compliance and governance guardian:** Create an agent that monitors development artifacts (commits, documents, configs) and autonomously flags policy violations, suggests fixes, or applies compliant templates to ensure secure-by-default delivery or reduces manual governance overhead.

- **Smart incident prevention agent:** Develop an agentic solution that proactively monitors logs and metrics, identifies early-risk indicators, compiles diagnostic information, alerts teams, or automatically starts remediation playbooks to prevent outages and drastically reduce Mean Time To Repair (MTTR).

- **Multi-tool enterprise workflow choreographer:** Explore how agentic AI could dynamically coordinate workflows across siloed enterprise tools such as ServiceNow, GitHub, Slack, or Confluence, without human orchestration to compress operational response time or eliminate manual tool switching. For example, when a customer incident is detected, the solution might auto-create a ticket or assemble a virtual response team. It could then gather logs, draft a root-cause hypothesis, or prepare a postmortem template.

---

© 2026 IBM Corporation

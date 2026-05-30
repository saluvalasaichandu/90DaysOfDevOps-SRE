
## Task 3: Configure and Scale Jenkins Agents/Nodes

**Scenario:**  
Your build workload has increased, and you need to configure multiple agents (across different OS types) to distribute the load.

**Steps:**
1. **Set Up Multiple Agents:**  
   - Configure at least two agents (e.g., one Linux-based and one Windows-based) in Jenkins.
   - Use Docker containers or VMs to simulate different environments.
2. **Label Agents:**  
   - Assign labels (e.g., `linux`, `windows`) and modify your Jenkinsfile to run appropriate stages on the correct agent.
3. **Run Parallel Jobs:**  
   - Create jobs that run in parallel across these agents.
4. **Document in `solution.md`:**  
   - Explain how you configured and verified each agent.
   - Describe the benefits of distributed builds in terms of speed and reliability.

**Interview Questions:**
- What are the benefits and challenges of using distributed agents in Jenkins?
- How can you ensure that jobs are assigned to the correct agent in a multi-platform environment?

---

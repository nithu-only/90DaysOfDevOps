**\### Day 26 -- GitHub CLI: Manage GitHub from Your Terminal  
  
\## Task:1 Install and Authenticate  
1. Install the GitHub CLI on your machine  
**Enter command in command prompt:  
winget install GitHub.cli

**2. Authenticate with your GitHub account**

gh auth login

![](media/image1.png){width="5.528301618547681in" height="2.8063517060367453in"}

**3. Verify you\'re logged in and check which account is active**

gh auth status

![](media/image2.png){width="5.65038823272091in" height="1.6900065616797901in"}

**4. What authentication methods does gh support?**

gh supports:

1.  Browser-based OAuth (recommended)

> → Opens browser for secure login

2.  Personal Access Token (PAT)

> → Used for automation & CI

3.  SSH authentication

> → Uses existing SSH keys

4.  GitHub Enterprise authentication

> → Supports enterprise servers

**\## Task:2 Working with Repositories**

1.  **Create a new GitHub repo directly from the terminal --- make it public with a README**

> gh repo create my-test-repo \--public \--clone \--add-readme
>
> ![](media/image3.png){width="5.773885608048994in" height="0.4921423884514436in"}
>
> ![](media/image4.png){width="7.178627515310586in" height="3.9538943569553804in"}

2.  **Clone a repo using gh instead of git clone**

> gh repo clone TrainWithShubham/python-for-devops
>
> ![](media/image5.png){width="6.350884733158355in" height="1.900515091863517in"}

3.  **View details of one of your repos from the terminal**

> gh repo view my-test-repo
>
> ![](media/image6.png){width="5.832697944006999in" height="1.657308617672791in"}

4.  **List all your repositories**

> gh repo list
>
> ![](media/image7.png){width="8.36988079615048in" height="2.3003226159230095in"}

5.  **Open a repo in your browser directly from the terminal**

> gh repo view --web
>
> ![](media/image8.png){width="9.173846237970254in" height="3.6656583552055992in"}

6.  **Delete the test repo you created (be careful!)**

> gh auth refresh -h github.com -s delete_repo
>
> gh repo delete my-test-repo ---yes
>
> ![](media/image9.png){width="9.173957786526683in" height="1.960987532808399in"}

**\##Task:3 Issues**

1.  **Create an issue on one of your repos from the terminal --- give it a title, body, and a label**

> gh issue create \--title \"Bug in login flow\" \--body \"Users cannot login after update\" \--label bug
>
> ![](media/image10.png){width="8.681386701662293in" height="0.897432195975503in"}

2.  **List all open issues on that repo**

> gh issue list
>
> ![](media/image11.png){width="8.280393700787402in" height="0.45496719160104987in"}

3.  **View a specific issue by its number**

> gh issue view 1
>
> ![](media/image12.png){width="6.130218722659667in" height="0.32604221347331586in"}

4.  **Close an issue from the terminal**

> gh issue close 1
>
> ![](media/image13.png){width="6.207258311461067in" height="0.34449365704286966in"}

5.  **How could you use gh issue in a script or automation?**

> gh issue can be scripted to:

- Auto-create issues from monitoring alerts

- Create bug tickets from CI failures

- Generate weekly backlog items

- Track incidents automatically

**\## Task:4 Pull Requests**

1.  **Create a branch, make a change, push it, and create a pull request entirely from the terminal**

> git checkout -b feature-update
>
> echo \"update\" \>\> file.txt
>
> git add .
>
> git commit -am \"update file\"
>
> git push origin feature-update
>
> ![](media/image14.png){width="9.74928915135608in" height="7.451755249343832in"}

2.  **List all open PRs on a repo  
    Create a PR:**

> gh pr create --fill
>
> ![](media/image15.png){width="8.691026902887138in" height="0.957409230096238in"}
>
> ![](media/image16.png){width="8.849178696412949in" height="2.6883573928258966in"}
>
> **To List open PRs**
>
> gh pr list
>
> ![](media/image17.png){width="9.05830161854768in" height="1.3522714348206475in"}

3.  **View the details of your PR --- check its status, reviewers, and checks**

> gh pr view 1
>
> ![](media/image18.png){width="10.792540463692038in" height="2.2054516622922136in"}

4.  **Merge your PR from the terminal**

> gh pr merge 1 --merge

5.  **Answer in your notes:**

- **What merge methods does gh pr merge support?**

> gh pr merge \--merge \# merge commit
>
> gh pr merge \--squash \# squash commits
>
> gh pr merge \--rebase \# rebase & merge

- **How would you review someone else\'s PR using gh?**

> gh pr checkout 15 \# checkout PR locally
>
> gh pr review 15 \--approve
>
> gh pr review 15 \--comment -b \"Looks good\"
>
> gh pr review 15 \--request-changes -b \"Please fix formatting\"

**\## Task : 5 GitHub Actions & Workflows (Preview)**

1.  **List the workflow runs on any public repo that uses GitHub Actions**

> gh run list

2.  **View the status of a specific workflow run**

> gh run view \<run-id\> \--log

3.  **Answer in your notes: How could gh run and gh workflow be useful in a CI/CD pipeline?**

> gh run & gh workflow help:

- Monitor pipeline status from terminal

- Auto-fail deployments if checks fail

- Trigger workflows manually

- Fetch logs for debugging

- Integrate pipeline status into scripts

**\## Task 6: Useful gh Tricks**

**Explore and try these --- add the ones you find useful to your git-commands.md:**

1.  **gh api --- make raw GitHub API calls from the terminal**

> gh api repos/:owner/:repo/issues
>
> ![](media/image19.png){width="12.387906824146981in" height="7.612378608923884in"}

2.  **gh gist --- create and manage GitHub Gists**

> gh gist create notes.txt

3.  **gh release --- create and manage releases**

> gh release create v1.0 \--notes \"First release\"
>
> ![](media/image20.png){width="10.00471675415573in" height="0.41495516185476816in"}

4.  **gh alias --- create shortcuts for commands you use often**

> gh alias set prs \"pr list\"
>
> gh prs
>
> ![](media/image21.png){width="8.576097987751531in" height="1.7925863954505687in"}

5.  **gh search repos --- search GitHub repos from the terminal**

> gh search repos terraform aws
>
> ![](media/image22.png){width="13.653955599300087in" height="7.802075678040245in"}

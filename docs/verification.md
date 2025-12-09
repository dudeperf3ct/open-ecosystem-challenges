# Verify Your Solution

Each challenge includes a three-step verification process to help you validate and share your solution:

1. **Local Smoke Test** - Quick validation in your Codespace
2. **Full Verification Workflow** - Comprehensive validation via GitHub Actions
3. **Submit Your Results** - Share your success with the community

This process is designed to give you confidence in your solution without directly revealing the answers.

## 🧪 Step 1: Local Smoke Test

The smoke test is a script that runs directly in your Codespace to check basic success criteria.

### What It Checks

- ✅ Basic functionality (e.g., services are reachable)
- ✅ Key resources are deployed correctly
- ✅ Essential configuration is in place

### What It Doesn't Check

The smoke test deliberately avoids checking certain criteria to prevent revealing the solution. These more complex
validations are performed by the full verification workflow.

### How to Run

Each challenge level has its own smoke test script. Run it from the repository root:

```bash
adventures/<adventure-name>/<level>/smoke-test.sh
```

**Example for Adventure 01, Beginner level:**

```bash
adventures/01-echoes-lost-in-orbit/easy/smoke-test.sh
```

### Understanding the Results

✅ **If the smoke test passes:**

- Your solution likely meets all requirements
- Proceed to Step 2 for full verification

❌ **If the smoke test fails:**

- Review the error messages and hints provided
- Check your solution against the challenge objectives
- Make adjustments and run the test again

## 🔄 Step 2: Full Verification Workflow

The full verification workflow runs on GitHub Actions and performs comprehensive validation of your solution.

### Prerequisites

#### Enable GitHub Actions in Your Fork

If this is a **new fork**, GitHub Actions workflows are disabled by default. You need to enable them:

1. Go to your fork on GitHub
2. Click the **Actions** tab
3. Click the green button **"I understand my workflows, go ahead and enable them"**

> 💡 **Note:** This is a one-time setup for your fork. Once enabled, workflows will be available for all challenges.

### Running the Verification Workflow

The verification workflow validates more complex success criteria that cannot be checked locally without revealing the
solution.

#### When to Run

Run the verification workflow **after** your smoke test passes.

#### How to Run

1. **Commit and push your changes** to the `main` branch of your fork:
   ```bash
   git add .
   git commit -m "Solved Adventure 01 - Easy level"
   git push origin main
   ```

2. **Manually trigger the workflow** on GitHub:
    - Go to your fork on GitHub
    - Click the **Actions** tab
    - Select the **"Verify Adventure"** workflow from the left sidebar
    - Click the **"Run workflow"** dropdown button
    - Select the challenge you want to verify (e.g., `Adventure 01 | 🟢 Easy (Broken Echoes)`)
    - Click **"Run workflow"**

3. **Wait for the workflow to complete**

### Understanding the Results

✅ **If the workflow passes:**

- 🎉 Congratulations! You've successfully completed the challenge!
- Proceed to Step 3 to claim your completion

❌ **If the workflow fails:**

- Click on the failed workflow run to see detailed logs
- Review what criteria were not met
- Adjust your solution and try again
- Don't hesitate to [open a discussion](https://community.open-ecosystem.com/c/challenges) if you're stuck

## 📸 Step 3: Submit Your Results

Once your verification workflow passes, it's time to share your success with the community!

### How to Submit

1. **Take a screenshot** of your successful workflow run on GitHub Actions
    - The screenshot should show the green checkmark and "Success" status
    - Include the workflow name and your GitHub username in the screenshot

2. **Post your screenshot** as a comment to the original challenge thread
    - Find the discussion thread for your specific adventure and level
    - Add a comment with your screenshot
    - Optionally, share any interesting learnings or challenges you faced 🙌

3. **Celebrate!** 🎉
    - You've officially completed the challenge
    - Your contribution is now part of the Open Ecosystem community
    - Ready for more? Move on to the next level or choose another adventure!

### Why Submit?

- **Recognition**: Get acknowledged by the community for your achievement
- **Inspiration**: Help motivate others who are working on the same challenge
- **Community**: Connect with fellow learners and share insights
- **Progress Tracking**: Keep a record of your completed challenges

## 🎯 Tips for Success

- **Read the challenge objectives carefully**: They outline exactly what needs to be achieved
- **Run the smoke test before committing**: It provides fast feedback during development
- **Check the workflow logs**: They contain valuable debugging information if verification fails
- **Don't give up**: These challenges are designed to be... challenging! Learning happens through iteration

## 🤝 Need Help?

If you're stuck or have questions about verification:

- 💬 [Start a discussion](https://community.open-ecosystem.com/c/challenges)
- 🐛 [Report an issue](https://github.com/dynatrace-oss/open-ecosystem-challenges/issues) if you think something is
  broken
- 📖 Check the adventure-specific documentation for hints and resources

## 🔒 Why This Verification Process?

The three-step approach balances learning, validation, and community engagement:

- **Smoke tests** give you fast, local feedback without an internet connection
- **Workflow verification** ensures comprehensive validation without giving away solutions in the local scripts
- **Community submission** celebrates your achievement and contributes to the learning ecosystem 

Together, they provide confidence that your solution is correct while preserving the learning experience

Happy solving! 🚀


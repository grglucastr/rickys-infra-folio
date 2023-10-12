// 1. Retrieve existing bot comments for the PR
const { data: comments } = await github.rest.issues.listComments({
  owner: context.repo.owner,
  repo: context.repo.repo,
  issue_number: context.issue.number,
});

const botComment = comments.find(comment => {
  return comment.user.type === 'Bot' && comment.body.includes('Terraform Cloud Plan Output')
});

const output = `#### Terraform Cloud Plan Output
   \`\`\`
   Plan: ${{ steps.plan-output.outputs.add }} to add, ${{ steps.plan-output.outputs.change }} to change, ${{ steps.plan-output.outputs.destroy }} to destroy.
   \`\`\`
   [Terraform Cloud Plan](${{ steps.plan-run.outputs.run_link }})
   `;
// 3. Delete previous comment so PR timeline makes sense
if (botComment) {
  github.rest.issues.deleteComment({
    owner: context.repo.owner,
    repo: context.repo.repo,
    comment_id: botComment.id,
  });
}
github.rest.issues.createComment({
  issue_number: context.issue.number,
  owner: context.repo.owner,
  repo: context.repo.repo,
  body: output
});
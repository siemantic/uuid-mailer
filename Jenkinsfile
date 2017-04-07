node('node') {
  currentBuild.result = "SUCCESS"

  try {

    stage 'Checkout'

      checkout scm

    stage 'Test'

      sh "source '/var/lib/jenkins/.nvm/nvm.sh'"
      sh 'node -v'
      sh 'git clean -fdx'
      sh 'npm install'
      sh 'npm test'

    stage 'Build Docker'

      sh "git rev-parse --short HEAD > .git/commit-id"
      commit_id = readFile('.git/commit-id')
      sh "./dockerfiles/build.sh storjlabs/uuid-mailer:${env.BUILD_ID} storjlabs/uuid-mailer:${commit_id} storjlabs/uuid-mailer:latest"
      sh "./dockerfiles/push.sh storjlabs/uuid-mailer:${env.BUILD_ID} storjlabs/uuid-mailer:${commit_id} storjlabs/uuid-mailer:latest"

    stage 'Deploy to Staging'

      echo 'Push to Repo'
      sh './dockerfiles/deploy.staging.sh uuid-mailer storjlabs/uuid-mailer:${env.BUILD_ID}'

    stage 'Cleanup'

      echo 'prune and cleanup'
      sh "source '/var/lib/jenkins/.nvm/nvm.sh'"
      sh 'rm node_modules -rf'

      mail body: 'project build successful',
        from: 'build@storj.io',
        replyTo: 'build@storj.io',
        subject: 'project build successful',
        to: "${env.CHANGE_AUTHOR_EMAIL}"
      }

  catch (err) {
    currentBuild.result = "FAILURE"

    mail body: "project build error is here: ${env.BUILD_URL}" ,
      from: 'build@storj.io',
      replyTo: 'build@storj.io',
      subject: 'project build failed',
      to: "${env.CHANGE_AUTHOR_EMAIL}"

      throw err
  }
}

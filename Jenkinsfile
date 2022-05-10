pipeline {
  agent none
  environment {
    ID_DOCKER = "matt2022dockertp"
    IMAGE_NAME = "django"
    IMAGE_TAG = "nightly"
    DOCKERHUB_PASSWORD = credentials('dockerhubpassword')
    IMAGE_POSTGRES = "docker.io/postgres:14.2-alpine"
  }

  stages {

    stage('Build Front-End Image') {
      agent any
      steps {
        script {
          sh 'docker build -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG ./'
        }
      }
    }

    stage('Run Front-End container') {
      agent any
      steps {
        script {
          sh '''
            docker rm -f $IMAGE_NAME
            docker run --rm --name $IMAGE_NAME -d -p 8000:8000 ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
            sleep 5
          '''
        }
      }
    }

    stage('Failure testing of Front-End missing-DB') {
      agent any
      steps {
        script {
          sh '''
            docker logs django > filelog
            if grep -q Retry filelog; then echo "Successfully failed: no db response!"; else exit 1; fi;
            docker stop $IMAGE_NAME
          '''
        }
      }
    }

    stage('Postgres Functional test') {
      agent any
      steps {
        script {
          sh '''
            docker rm -f postgres
            docker run -tdi --rm --name postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres $IMAGE_POSTGRES
            sleep 5
            docker exec postgres psql --username=postgres
            docker stop postgres
          '''
        }
      }
    }

    stage('Run Django Full App') {
      agent any
      steps {
        script {
          sh '''
            docker-compose up -d
            sleep 10
          '''
        }
      }
    }

     stage('Test Django Full App') {
       agent any
       steps {
         script {
          sh '''
            curl http://localhost:8000 | grep -i "album"
          '''
         }
       }
     }

     stage('Django App Shutdown') {
       agent any
       steps {
         script {
           sh '''
            docker-compose down
          '''
         }
       }
     }

      stage('Front-End image artefact Delivery (on Docker hub)') {
        agent any
        steps {
          script {
            sh '''
              echo $DOCKERHUB_PASSWORD | docker login -u $ID_DOCKER --password-stdin
              docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
            '''
         }
       }
     }
        
     stage('Prepare Ansible Deployment environment') {
            agent any
            environment {
                PRIVATE_KEY = credentials('private_keys_jenkins')
            }
            steps {
                sh '''
                     cp  $PRIVATE_KEY  id_rsa
                     chmod 600 id_rsa
                '''
            }
     }          
          
     stage('Deploy Staging env.') { 
           agent any
           steps {
               script {
                 sh '''
                     cd $WORKSPACE/ansible && ansible-playbook playbooks/deploy_app.yml  --private-key ../id_rsa -e env=staging                   
                 '''
               }
           }
     }
     stage('Deploy Staging env.') {
          when {
              expression { GIT_BRANCH == 'origin/release' }
          }
          agent any
          steps {
               script {
                 sh '''
                     cd $WORKSPACE/ansible && ansible-playbook playbooks/deploy_app.yml  --private-key ../id_rsa -e env=prod
                 '''
               }
          }
     }
          
     stage('Remove temp files') {
            agent any
            steps {
                sh '''
                     rm -fr $WORKSPACE/ansible/id_rsa
                '''
            }
     }            
  }
}

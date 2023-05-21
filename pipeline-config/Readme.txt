after setting up the envrionment:

connect the TestVM, ( its not best practice, but it will also serve us as a conatiner for the jenkins pipeline, due to quota limits)

download docker desktop, wsl, az cli:

######
Part 1
######

# open the wsl

# first time using wsl (configure user, password)

#start docker
sudo service docker start

# clone joska repo (friend tested jenkins container, that you are going to change using our own Dockerfile)
git clone https://github.com/Joska99/joska.git

# move to the desired directory 
cd /joska/docker/stateful-jenkins

# delete his Dockerfile, we are using ours.
rm Dockerfile

# go to github and copy the Dockerfile content from devops-project/pipeline-config

# create a Dockerfile back in wsl
vim Docker file

# paste the content
Click i (for insert mode), then right click, save with Esc + :wq.

# Build the Image
docker build -t stateful-jenkins  .

# Run the conatiner and enter jenkins (after the creation you can access the jenkins using 127.0.0.1:8000 / localhost:8000)
docker run -p 8000:8080 -p 50000:50000  -v /var/run/docker.sock:/var/run/docker.sock -d --name stf-jenkins --restart=on-failure -t stateful-jenkins

# it might take few minutes for the jenkins server.

######
Part 2
######

#Connect to Jenkins container
docker exec -it --user root stf-jenkins bash

#Run the following command to retrive the output:
cat /var/jenkins_home/secrets/initialAdminPassword

# enter the output as the password in jenkins
# create your credentials, next time you connect to the container by them

# install the following plugins
- Azure Cli - Docker pipeline - Azure credentials - Kubernetes Cli

# create new pipeline
From left top pane click +New Item --> enter a name for the pipeline, select the type and press ok.

# configure the pipeline
copy from devops-project/pipeline-config/pipeline-code
and paste it in the script area.

# add trigger
scroll up and look for "Build periodically" and add this
TZ=Asia/Jerusalem
H 10 * * 0,2,4,6

# save, and create another pipeline using the same syntax exepct the build trigger,
at the build trigger add this syntax: 
TZ=Asia/Jerusalem
H 10 * * 1,3,5,7

# change the code to get the seccond key this time, and rotate the first one.
change line 41 to this: 'script: "az storage account keys list -n ${env.AZURE_STORAGE_ACCOUNT} --query '[1].value' -o tsv"'

change line 56 to this: 'sh "az storage account keys renew -n ${env.AZURE_STORAGE_ACCOUNT} --resource-group ${env.AZURE_RESOURCE_GROUP} --key key1"'

if we used the value of 0 in line 41 we would have get key 1, in line 56 we changed to rotate key1 instead of key2.

# save the pipe line, thats it.


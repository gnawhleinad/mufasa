Play with [P4D](http://www.perforce.com/p4d), [Swarm](http://www.perforce.com/swarm), and [Jenkins](http://jenkins-ci.org/)

# Usage
## Pre-requisites
- [vagrant-1.7.x](http://www.vagrantup.com/downloads.html)
- [VirtualBox-4.3.x](https://www.virtualbox.org/wiki/Downloads)

## Setup
### P4D/Swarm
1. Start the `p4d` machine:
        $ vagrant up p4d
2. Log in via `http://localhost:8080`:
        Username: mufasa
        Password: mufasa
3. Add a project via `http://localhost:8080/projects/add`:
        Name: main
        Members: mufasa
        Branches: 
            Name: master
            Path: //depot/...
        Automated Tests: Enabled
            URL: http://jenkins.test:8080/job/swarm_main/review/build?status={status}&review={review}&change={change}&pass={pass}&fail={fail}

### Jenkins
1. Start the `jenkins` machine:
        $ vagrant up jenkins
2. Add credential via `http://localhost:8081/credential-store/domain/_/newCredentials`:
        Kind: Perforce Password Credential
        Description: p4d.test
        P4Port: p4d.test:1666
        Username: mufasa
        Password: mufasa
3. Add a label via `http://localhost:8081/computer/(master)/configure`:
        Labels: swarm
4. Add a item via `http://localhost:8081/view/All/newJob`:
        Item name: swarm_main
        Type: Freestyle project

        Restrict where this project can be run:
            Label Expression: swarm
        Source Code Managment:
            Type: Perforce Software
            Workspace behaviour: Manual (custom view)
                Workspace name: jenkins
                View Mappings: //depot/... //jenkins/...
        Populate options: Auto cleanup and sync
            REPLACE missing/modified files
            DELETE generated files
        Repository browser: Swarm browser
            URL: http://localhost:8080
        Add build step: Execute shell
            Command: make -k > build.log 2>&1
        Add post-build action: Archive the artifacts
            Files to artifact: build.log

# Play
## Automated Tests
This section will demonstrate the automated task queued after requesing a review.
1. Log in:
        $ vagrant ssh p4d
2. Edit and shelve:
        $ cd depot
        $ p4 edit rememberwhoyouare.c
        $ p4 shelve
3. Request a review via `http://localhost:8080/changes/{changelist}`
4. Check the build status via `http://localhost:8081/job/swarm_main`
5. Check the review status via `http://localhost:8080/reviews/{review}`

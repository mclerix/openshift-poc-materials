def inputWithRBAC () {
    openshift.withCluster() {
        openshift.withProject() {
            def rolebindings = openshift.selector('rolebindings')
            def submitters = ""

            rolebindings.withEach {
                if (it.object().roleRef.name == "jenkins-release") {
                    it.object().userNames.each { String name ->
                        submitters += name + "-admin,"
                        submitters += name + "-view,"
                        submitters += name + "-edit,"
                        submitters += name + "-jenkins-release,"
                    }
                }
            }

            echo "Allowed submitters : ${submitters}"

            def submitter = input message: 'Do you want to proceed ?', submitter: "${submitters}", submitterParameter: 'submitter_user'
        }
    }
}

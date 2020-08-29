## Steps
1. Register new Oauth app - https://github.com/settings/applications/new
2. Provide the homepage URL which will be in the following format -   https://oauth-openshift.apps.`<cluster-name>.<cluster-domain>`
3. Provide the authorization callback URL which will be in the following format - https://oauth-openshift.apps.`<cluster-name>.<cluster-domain>`/oauth2callback/github/
4. Register Application. Successful registration will provide `Client ID` and a `Client Secret`.
5. Run the script to setup Github Auth
```
$ bash configure_github_auth.sh <Client ID> <Client Secret> <Github Organization>
```

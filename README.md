# Experiment with Salesforce Einstein's Language Sentiment API and Process Builder
Experimenting with Salesforce Einstein's Language Sentiment API - https://metamind.readme.io/docs/prediction-sentiment. Incorporating the use of Process Builder and Invocable Apex Methods to analyse sentiment on emails and notes of logged calls. The sentiment results are captured in three custom fields on the EmailMessage object and the Activity object (pending on the Process Builder used).

<h2>Prerequisites</h2>
<ol>
<li>Get an Einstein Platform Account using your Salesforce login at https://api.metamind.io/signup</li>
<li>Download the private key and upload it into Salesforce Files in the org you are wanting to use</li>
<li>Install the following Apex classes from - https://github.com/salesforceidentity/jwt</li>
<li>Install the following Apex classes from - https://github.com/MetaMind/apex-utils</li>
</ol>
<h2>Install</h2>
<a href="https://githubsfdeploy.herokuapp.com?owner=Clint-Chester&repo=sfdc-einstein-language-sentiment&ref=master">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
<h2>Post Install</h2>
<ol>
<li>Update Custom Metadata "Access Email" under Einstein Setting to the email address that you used when signing up for an Einstein Platform Account</li>
</ol>

# shinyapp_email_activity

This repo sets up an online Shiny App via R to evaluate and visualize efficiency
of email marketing communication. It analyzes online marketing data reflecting recipients engagement for IBM Marketing
Cloud data using Recipient.Id (therefore it is completely anonymous).

You can find out more about building applications with Shiny here
http://shiny.rstudio.com.


# Shiny App Authorisation

First create your Shiny App account, retrieve you token and secret. Set up the application 
visibility for users (private x public mode).


# Using the Shiny Dashboard

Upon successfully deploying and running the app, navigate to your dashboard.

In the web UI load IBM Marketing cloud data export (default csv format) and enter the costs
for the same period of time in the dedicated field.

Run the evaluation by clicking the Choose file button.


# Outcomes

Three tabs will be displayed upon processing the data:
1. Outcome description - detailed outcome documentations
2. Visualize activity rate - graphical representation
3. Activity rate table - complete table with the summary list


## Visualization

The Activity Rate Graph tab provides a graphical representation of the activity of email
subscribers. The x-axis shows the level of activity, ie how customers have been involved
in their entire history at IBM Marketing Cloud. The y-axis shows the number of customers
with a given level of activity. The price tag for each group of recipients expresses the
cost of sending emails to everyone in the group with a given level of activity.

If the Activity RateM = 0, then it means that the recipient does not perform any activity
(ie he does not even open emails). If the Activity Rate is greater than 1, the recipient
performs on average more than one action per email received.

The graph reflects the activity rate only for values between 0 and 1. For a more detailed
view of more active customers (ie also those with activity rate > 1), the complete list is
shown on the Activity Rate tab.
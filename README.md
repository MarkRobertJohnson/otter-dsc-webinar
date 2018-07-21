# Otter Git Raft and DSC Resource Setup

## Overview

This repository contains Otter scripts, PowerShell script, and other resource you can use to bootstrap your Otter setup.

## First-time Otter Setup

The first thing you will want to do is install Otter, you can download the latest installer from https://inedo.com/otter/versions. 

After you have installed Otter, you will want to create a fork of this repository.  

## Setup infrastructure

This will create roles and additional servers

First open the  infrastructure JSON file located at https://github.com/MarkRobertJohnson/otter-dsc-webinar/blob/dev/setup/otter_dsc_webinar_infrastructure_setup.json 

Copy the contents of that file.

Then open the Administration section (the Gear icon in the upper right of the screen ![image](https://user-images.githubusercontent.com/24645219/42730032-691c4e2a-879f-11e8-8e28-ba4077e8c26a.png))

Click the **Import Configuration** link in the **Infrastructure** section

![16](https://user-images.githubusercontent.com/24645219/43032777-c472f2aa-8c73-11e8-8b5f-6788de7d5a12.png)
 
Uncheck **Delete missing** and **Dry-run mode**

![17](https://user-images.githubusercontent.com/24645219/43032778-c5d8822c-8c73-11e8-8bb3-84859d595470.png)
 
Then click **Import**

This will create three additional servers, multiple roles and four environments

## Setup a new Git Raft

Rafts are the mechanism by which content is stored in Otter.  We will focus on using Git Rafts for now because they lend themselves to working with infrastructure in a very code-like way.

You then can create a new Otter Git raft by doing:

1)	Open your local Otter instance (by default http://localhost:8626) 

2)	Go to the Administration section (the Gear icon in the upper right of the screen ![image](https://user-images.githubusercontent.com/24645219/42730032-691c4e2a-879f-11e8-8e28-ba4077e8c26a.png))

3)	Then click the “Rafts” link in the “Components & Extensibility” section
 
![2](https://user-images.githubusercontent.com/24645219/42769205-689dc180-88d6-11e8-90bb-893b58bb466e.png)
 
4)	Then click the “Create Raft” button

5)	Then click the “Git” button from the dialog window
 
![3](https://user-images.githubusercontent.com/24645219/42769644-a4be6e02-88d7-11e8-8d81-eeda0b92f984.png)

6)	You will now be presented with a dialog to configure the Git Raft
 
![4](https://user-images.githubusercontent.com/24645219/42769789-1dc69a9a-88d8-11e8-83ac-c1480f26c1e4.png)
 
7)	The Name (1) should be something meaningful, since we intend to replace the default raft with our new Git Raft, let’s name it “Default_New”

8)	In the  “Remote Repository UL” (2) put the address of your fork (i.e. https://github.com/MarkRobertJohnson/otter-dsc-webinar.git) 

9)	Then put your GitHub username and password in fields 3 & 4 (You can use other Git hosting services such as GitLab and BitBucket too)

10)	Then for the branch, let’s use the “dev” branch for the default (we generally would not want to edit directly on master, because we are trying embrace development best-practices)

11)	Then click save

12)	Then delete the existing “Default” raft (Click the red X)

13)	Then edit the “Default_New” rafts and rename it to “Default”

14)	The new Git raft is now set up and ready to go to work

15)	To verify the Git Raft is working, browse to “Assets” and you should see something like this (with the exception of multiple rafts, we will add more rafts later on)

![5](https://user-images.githubusercontent.com/24645219/42769216-6fa34b1c-88d6-11e8-91c7-2a3aeeeed346.png)

16)	Now, perform steps 4 through 15 each additional branch **prod, stage, and test** (Name the raft the same as the branch)

## Setup your LOCALHOST server

Goto **Servers** and click the **LOCALHOST** server

![18](https://user-images.githubusercontent.com/24645219/43032779-c7a2d6e8-8c73-11e8-8da5-d610978293e8.png)

Click the **edit** button
 
![19](https://user-images.githubusercontent.com/24645219/43032782-cdc33784-8c73-11e8-8e5b-819980a66575.png)

Rename **LOCALHOST** to **Dev-VM** (even though it is not a VM), then save

![20](https://user-images.githubusercontent.com/24645219/43032783-cdd9b356-8c73-11e8-871a-0b830082ce75.png)
 
Then assign the **Server DSC Resources** role

![21](https://user-images.githubusercontent.com/24645219/43032784-cdf041c0-8c73-11e8-9589-a3efe61f0b72.png)

The **Dev-VM** server is now ready for use in the subsequent tutorials

Now , click the **Check Configuration** button

It should detect drift.

Then click the **Remediate with Job** button

![22](https://user-images.githubusercontent.com/24645219/43032785-ce05326a-8c73-11e8-946e-e7a90479573b.png)

## Tutorial: Using DSC Resources in Otter

Otter allows using most, if not all DSC resources directly within OtterScript.  This tutorial will walk you through how to execute your first DSC resource

First, go to the Servers, you will see one server named “LOCALHOST”, that is your local machine.  Click LOCALHOST to go to the server page then scroll down to the “Configuration Plan” section, and click “create”

![6](https://user-images.githubusercontent.com/24645219/42769650-a8408bc8-88d7-11e8-9618-9553f840155b.png)

An editor window will now pop up, click the purple “Switch to Text Mode” button in the lower right (DSC resources can only be created in Text Mode)

![7](https://user-images.githubusercontent.com/24645219/42769233-778e64e2-88d6-11e8-8742-e3f5b69f1e42.png)

Then copy and paste this Otter script:

~~~
PSDsc Environment (
   Name: MyFirstOtterVar,
   Value: This variable is set on $ServerName,
   Ensure: Present,
   Path: false
);
~~~

Then click the **Save Plan** button.  The dialog will close and you will return to the server screen.  The server should now check the configuration automatically, if not, click the **Check Configuration** button

![8](https://user-images.githubusercontent.com/24645219/42769237-79cbe810-88d6-11e8-8ad0-d6b945f029fd.png)

Wait for the configuration check to complete

![9](https://user-images.githubusercontent.com/24645219/42769241-7d02c850-88d6-11e8-87de-28b483ac38c1.png)

The server will be in a drifted state.  Click the **Configuration** tab to see the details of the drift

![10](https://user-images.githubusercontent.com/24645219/42769245-7f7ec610-88d6-11e8-89ab-4d6830fb6ec5.png)

Click the **MyFirstOtterVar** entry in the **DSC-Environment** section, and you will see a dialog like:

![11](https://user-images.githubusercontent.com/24645219/42769792-204b8e42-88d8-11e8-948d-5100e28af77d.png)

Notice that the Ensure is **Absent**. Click the Close button of the dialog.

Now we will remediate this drift.  

Click the **Remediate with Job** button

![12](https://user-images.githubusercontent.com/24645219/42769253-86044f78-88d6-11e8-949b-54e01ba9e0ac.png)

![13](https://user-images.githubusercontent.com/24645219/42769254-871b0ff0-88d6-11e8-8380-def93af95991.png)

A new job is now launches to automatically remediate the drift.  In this case, a new environment variable is created named **MyFirstOtterVar**

![14](https://user-images.githubusercontent.com/24645219/42769257-88970b86-88d6-11e8-88c5-32d5e3da4efa.png)

To verify that the environment variable was really set, open a PowerShell console and execute

~~~
[environment]::GetEnvironmentVariable("MyFirstOtterVar", "Machine")
~~~

You should see "This variable is set on Dev-VM" printed out

Also, on the server’s configuration tab, you should now see
 
![15](https://user-images.githubusercontent.com/24645219/42769263-8ab7a88a-88d6-11e8-8516-0050143ee141.png)

## Tutorial: Using DSC Configuration Scripts in Otter to Set Environment variables

Make sure you have setup the Otter Raft as described in **Setup a New Otter Raft**

Goto the "DSC_Win2016Server" in script Assets and open it

![23](https://user-images.githubusercontent.com/24645219/43032786-ce1b23a4-8c73-11e8-89c6-ce1c120ca86e.png)

Change the values of the variables, then click **Save**

1) Display the server’s current values by running this PowerShell command on your localhost (run PowerShell as Administrator):

~~~

@('var1', 'var2', 'var3') | foreach { $val = 
[environment]::GetEnvironmentVariable($_, 'machine'); echo "'$($_)' is '$val'"} 

~~~

2) Run the dev server’s Configuration check
3) View the Dev server’s configuration to see the drifted variables
4) Run the Remediation for the Dev server
5) View the configuration to see that the variables remediated
6) Run this powershell on the dev server

~~~

@('var1', 'var2', 'var3') | foreach { $val = 
[environment]::GetEnvironmentVariable($_, 'machine'); echo "'$($_)' is '$val'"}

~~~

## Troubleshooting

### DSC

If you ever encounter the error:

~~~

Cannot invoke the Test-DscConfiguration cmdlet. The Consistency Check or Pull cmdlet is in progress and 
must return before Test-DscConfiguration can be invoked. Use -Force option if that is available to cancel 
the current operation.
 
~~~

Run this code on the affected server:

~~~

#Remove all mof files (pending,current,backup,MetaConfig.mof,caches,etc)
rm C:\windows\system32\Configuration\*.mof*
#Kill the LCM/DSC processes
gps wmi* | ? {$_.modules.ModuleName -like "*DSC*"} | stop-process -force 

~~~


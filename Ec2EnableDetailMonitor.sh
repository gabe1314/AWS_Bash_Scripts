#!/bin/bash

### Variables 
#COLORS
green='\033[0;32m'
red='\033[0;31m'
blue='\033[0;34m'
NC='\033[0m'
#Region="eu-west-1"
export AWS_DEFAULT_OUTPUT="table"


### FUNCTIONS ###

############################
## Ask User Region 
AskOne (){
echo -n "Enter your Account ID :  "
read AccountID

echo -n "Enter the Region where the instance that need detailed-monitoring enabled:  "
read Region

echo -n "Enter the day of creation of the instances (YYYY-MM-DD) :  "
read DateInstance
echo ""
echo "Please wait for the instances list to be generated..."
echo ""
}


############################
## Describe the selected Instances for ONE day
DescribeOne (){
aws ec2 describe-instances --region $Region --instance-ids --filters "Name=monitoring-state,Values=disabled" --query 'Reservations[*].Instances[].[InstanceId, State.Name, Monitoring.State]' --output text|grep running|awk '{print$1}' > /tmp/us-east-1-instances | grep -A 7 $AccountID
}


############################
## Enable the selected Instances for ONE day
EnableOne(){
for i in `cat /tmp/us-east-1-instances`; do aws ec2 monitor-instances --region us-east-1 --instance-ids $i; done
}

############################
## Main Menu
MainMenu() {
echo ""
echo "$(date)"
echo "-------------------------------"   
echo -e   "  ${red}Select an Option${NC}"
echo "-------------------------------"
echo ""
echo "1. One day instanes enabled"
echo ""
echo ""
return 2;
}

############################
## Read the Main menu
read_MainMenu(){
echo "Please select option 1"
read option
case $option in
      1) 
         echo ""
         AskOne
         DescribeOne
         menuOne
         read_optionsOne
			echo ""
      	;;
		*)
			echo "Error: Invalid option..."	
			read -p "Press [Enter] key to continue..." readEnterKey
			;;
    esac
}

############################
## Menu for confirmation
menuOne() {
echo ""
echo "$(date)"
echo "-------------------------------"   
echo -e   "  ${red}Please confirm the instances to be enabled${NC}"
echo "-------------------------------"
echo ""
echo "1. Confirm the instances to be enabled"
echo "2. Cancel"
return 2;
}

############################
## Read the confirmation menu
read_optionsOne(){
echo "Please select option 1"
read option
case $option in
      1) 
         echo ""
			echo "Please wait for the ec2 instances detailed monitoring to be enabled..."
			echo ""
			EnableOne
      	;;
		2)
			return 1
			;;
		*)
			echo "Error: Invalid option..."	
			read -p "Press [Enter] key to continue..." readEnterKey
			;;
    esac
}

### Exec ###
clear
MainMenu
read_MainMenu

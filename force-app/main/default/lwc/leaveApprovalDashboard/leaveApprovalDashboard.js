import { LightningElement,wire } from 'lwc';
import {subscribe, unsubscribe, MessageContext} from 'lightning/messageService';
import LEAVE_REQUEST_CHANNEL from '@salesforce/messageChannel/LeaveRequestChannel__c';
import { NavigationMixin } from 'lightning/navigation';


export default class LeaveApprovalDashboard extends NavigationMixin(LightningElement) {

    receivedMessage = null;
    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        this.subscription = subscribe(
            this.messageContext,
            LEAVE_REQUEST_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    disconnectedCallback(){
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleMessage(message){
        this.receivedMessage = message;
    }

    handleNavigate(){
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:this.receivedMessage.id,
                objectApiName:'LeaveRequestTracker__c',
                actionName:'view'
            }
        });
    }

}
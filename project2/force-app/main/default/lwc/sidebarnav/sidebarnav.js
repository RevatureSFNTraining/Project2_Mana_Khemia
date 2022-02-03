import { LightningElement, wire } from 'lwc';
import {
    subscribe,
    unsubscribe,
    publish,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import Navigation from '@salesforce/messageChannel/Navigation__c';

export default class Sidebarnav extends LightningElement {
    @wire(MessageContext)
    messageContext;

    goHome(event) {
        const payload = {pageRedirect: ''};
        publish(this.messageContext, Navigation, payload);
    }
    goMyProfile(event) {
        const payload = {pageRedirect: 'myprofile'};
        publish(this.messageContext, Navigation, payload);
    }
    goMyWatchlist(event) {
        const payload = {pageRedirect: 'watchlist'};
        publish(this.messageContext, Navigation, payload);
    }
    goMessaging(event) {
        const payload = {pageRedirect: 'messaging'};
        publish(this.messageContext, Navigation, payload);
    }
    goSupport(event) {
        const payload = {pageRedirect: 'support'};
        publish(this.messageContext, Navigation, payload);
    }
    goAbout(event) {
        const payload = {pageRedirect: 'about'};
        publish(this.messageContext, Navigation, payload);
    }
}
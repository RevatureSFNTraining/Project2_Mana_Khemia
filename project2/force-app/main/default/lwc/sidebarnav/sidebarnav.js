import { LightningElement, wire } from 'lwc';
import {
    subscribe,
    unsubscribe,
    publish,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';

export default class Sidebarnav extends LightningElement {
    @wire(MessageContext)
    messageContext;

    goHome(event) {
        const payload = {pageRedirect: 'home'};
        publish(this.messageContext, Navigation, payload);
    }
    goMyProfile(event) {
        const payload = {pageRedirect: 'myprofile'};
        publish(this.messageContext, Navigation, payload);
    }
    goMyWatchlist(event) {
        const payload = {pageRedirect: 'mywatchlist'};
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
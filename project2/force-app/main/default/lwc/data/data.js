import { LightningElement, api } from 'lwc';

export default class DataTable extends LightningElement {

    @api subject = 'Subject';
    @api received = 'Received';
    @api from = 'From';
    @api message1 = 'New sign in activity on your eBay account';
    @api message2 = 'Nice to meet you, Vatsal!';
    @api message3 = 'Checkout incomplete: DEWALT DCCS620B 20V MAX Cordless Li-Ion 12 in. Compact Chainsaw (Tool Only) New Feb 24';
}
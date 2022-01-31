import { LightningElement, api } from 'lwc';

export default class Buttons extends LightningElement {
    @api Delete = 'Delete';
    @api Archive = 'Archive';
    @api Flagged = 'Flagged';
    @api Unread = 'Unread';
    @api Unflagged = 'Unflagged';
}
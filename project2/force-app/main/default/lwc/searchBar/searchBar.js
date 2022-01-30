import { LightningElement } from 'lwc';

export default class SearchBar extends LightningElement {

    searchInput;

    handleInput(event) {
        this.searchInput = "/s/global-search/" + event.target.value;
    }
}
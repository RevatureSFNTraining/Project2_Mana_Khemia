import { LightningElement } from 'lwc';

import EbayLogo from '@salesforce/resourceUrl/ebayLogo';
import ProfileIcon from '@salesforce/resourceUrl/profileIcon';

export default class Header extends LightningElement {

    ebayLogo = EbayLogo;
    profileIcon = ProfileIcon;
    searchInput;

    handleInput(event) {
        this.searchInput = "/s/global-search/" + event.target.value;
    }
    
    handleLogo(event) {
        // on click go to home page
        this.clickLogo = true;
    }

    handleProfile(event) {
        // on click go to user profile page
        this.clickProfile = true;
    }
}
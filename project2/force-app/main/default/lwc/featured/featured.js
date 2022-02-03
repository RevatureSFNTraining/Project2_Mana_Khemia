import { LightningElement } from 'lwc';
import FeaturedProducts from '@salesforce/resourceUrl/featuredProducts';

export default class Featured extends LightningElement {
  featuredProducts = FeaturedProducts;
}
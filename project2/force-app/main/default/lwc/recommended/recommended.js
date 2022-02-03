import { LightningElement } from 'lwc';
import PS5 from '@salesforce/resourceUrl/ps5';
import Pinball from '@salesforce/resourceUrl/pinball';
import Oculus from '@salesforce/resourceUrl/oculus';
import Celestron from '@salesforce/resourceUrl/celestron';
import Bella from '@salesforce/resourceUrl/bella';

export default class Recommended extends LightningElement {
  ps5 = PS5;
  pinball = Pinball;
  oculus = Oculus;
  celestron = Celestron;
  bella = Bella;
}
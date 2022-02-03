import { LightningElement } from 'lwc';
import ArmChair from '@salesforce/resourceUrl/armChair';
import DellLaptop from '@salesforce/resourceUrl/DellLaptop';
import XboxX from '@salesforce/resourceUrl/xboxX';
import xboxS from '@salesforce/resourceUrl/xboxS';
import LgTv from '@salesforce/resourceUrl/lgTv';

export default class Deals extends LightningElement {
  armChair = ArmChair;
  dellLaptop = DellLaptop;
  xboxX = XboxX;
  xboxS = xboxS;
  lgTv = LgTv;
}

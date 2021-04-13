import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-wison-area',
  templateUrl: './wison-area.component.html',
  styleUrls: ['./wison-area.component.css']
})
export class WisonAreaComponent implements OnInit {

  posicion = "(0 ,0)";

  constructor() { }

  ngOnInit(): void {
  }

}

import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { PruebaComponent } from './componentes/prueba.component';
import { PruebaSegundaComponent } from './prueba-segunda/prueba-segunda.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { WisonAreaComponent } from './wison-area/wison-area.component';

@NgModule({
  declarations: [
    AppComponent, PruebaComponent, PruebaSegundaComponent, WisonAreaComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

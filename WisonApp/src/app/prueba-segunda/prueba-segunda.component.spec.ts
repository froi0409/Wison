import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PruebaSegundaComponent } from './prueba-segunda.component';

describe('PruebaSegundaComponent', () => {
  let component: PruebaSegundaComponent;
  let fixture: ComponentFixture<PruebaSegundaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PruebaSegundaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PruebaSegundaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

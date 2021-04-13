import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WisonAreaComponent } from './wison-area.component';

describe('WisonAreaComponent', () => {
  let component: WisonAreaComponent;
  let fixture: ComponentFixture<WisonAreaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ WisonAreaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(WisonAreaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

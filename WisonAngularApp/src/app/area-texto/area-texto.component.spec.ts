import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AreaTextoComponent } from './area-texto.component';

describe('AreaTextoComponent', () => {
  let component: AreaTextoComponent;
  let fixture: ComponentFixture<AreaTextoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AreaTextoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AreaTextoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

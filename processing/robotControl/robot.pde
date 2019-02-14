class Robot {
  Servo[] servos;
  String[] states = {"Reset", "Walking", "Turning", "right_leg_forward", "iawf"};
  String state, previous_state;
  boolean move_in_progress;
  int stage;
  
  Robot() {
    state = previous_state = states[0];
    servos = new Servo[6];
    move_in_progress = false;
    stage = 0;
    for (int i = 0; i < servos.length; i++) {
      servos[i] = new Servo(i+1);
    }
    
    reset_servos();
  }
  
  void reset_servos() {
    setReg2(254, 30, 512); // all servos to center position
    setReg1(254, 25, 0); // turn off all leds
    setReg2(254, 32, 200); // setting the moving speed of all servos to half
    
    // setting the programmatical servos
    for (int i = 0; i < servos.length; i++) {
      servos[i].reset();
    }
    state = previous_state = states[0];
    
    move_in_progress = false;
    stage = 0;
  }
  
  void move_forward() {
    
    if (move_in_progress) {
      // there's another move in progress
      println("Must wait to move until another move has finished!");
      return;
    }
    move_in_progress = true;

    boolean cont_forward = false;
    // first we must check if the legs are parallell or not.
    if (previous_state.equals(states[3])) {
      cont_forward = true;
      println("continuing forward!");
    } else {
      //reset_servos(); // make sure they are indeed parallell!
      cont_forward = false;
      println("Resetting and going forward for the first time");
    }
    state = states[3]; 
    boolean done = false;
    int i = stage = 0;
    while(!done && i < 1000) {
      //println("At stage: "+stage);
      i++;
      if (cont_forward) {
          done = continue_forward();
      } else {
          done = move_forward_aux();
      }
      update();
    }
    
    if (i >= 1000) {
      println("failed");
    }
    stage = 0;
    previous_state = state;
    move_in_progress = false;
    return;
  }
  // assumes start is parallell.
  // moves left leg forward, then right leg in front.
  boolean move_forward_aux() {
    if (stage == 0) {
      // robot stand up
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      stage++;
      return false;
    } else if (stage == 1) {
      if (servos[1].moving || servos[4].moving) {return false;}
      servos[0].gotoSmooth(30);
      servos[5].gotoSmooth(30);
      stage++;
      return false;
    } else if (stage == 2) {
      if (servos[0].moving || servos[5].moving) {return false;}
      // tilt over the rest of the way
      servos[0].gotoSmooth(45);
      // lift left foott
      servos[4].gotoSmooth(15);      
      stage++;
      return false;
    } else if (stage == 3) {
      if (servos[0].moving || servos[4].moving) {return false;}
      // setting foot forward
      servos[2].gotoSmooth(15);
      servos[3].gotoSmooth(15);
      stage++;
      return false;
    } else if (stage == 4) {
      if (servos[2].moving || servos[3].moving) {return false;}
      // straightening up
      servos[0].gotoSmooth(30);
      servos[5].gotoSmooth(40);
      servos[4].gotoSmooth(-20);
      stage++;
      return false;
    } else if (stage == 5) {
      if (servos[4].moving || servos[0].moving || servos[5].moving) {return false;}
      // Truly straintengin up
      servos[0].gotoSmooth(0);
      servos[5].gotoSmooth(0);
      
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      stage++;
      return false;
    } else if (stage == 6) {
      // NEXT STEP=====================================================
      if (servos[0].moving || servos[5].moving || servos[1].moving || servos[4].moving) {return false;}
      // Shifting to left side
      servos[0].gotoSmooth(-20);
      servos[5].gotoSmooth(-20);
      stage++;
      return false;
    } else if (stage == 7) {
      if (servos[0].moving || servos[5].moving) {return false;}
      // tilting to the right the rest of the way
      servos[5].gotoSmooth(-45);
      servos[0].gotoSmooth(-35);
      // lifting left foot
      servos[1].gotoSmooth(-15);
      servos[4].gotoSmooth(-40);
      stage++;
      return false;
    } else if (stage == 8) {
      if (servos[5].moving || servos[1].moving || servos[0].moving || servos[4].moving) {return false;}
      // shift over
      servos[2].gotoSmooth(-15);
      servos[3].gotoSmooth(-15);
      stage++;
      return false;
    } else if (stage == 9) {
      if (servos[2].moving || servos[3].moving) {return false;}
      servos[0].gotoSmooth(-45);
      servos[5].gotoSmooth(-30);
      servos[1].gotoSmooth(20);
      stage++;
      return false;
    } else if (stage == 10) {
      if (servos[0].moving || servos[1].moving || servos[5].moving) {return false;}
      // Making the robot upright again
      servos[0].gotoSmooth(0);
      servos[5].gotoSmooth(0);
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      
      stage = 0;
      return true;
    } 
    return true;
  }
  
  boolean continue_forward() {
    if (stage == 0) {
      // tilt over
      servos[0].gotoSmooth(20);
      servos[5].gotoSmooth(20);
      stage++;
      return false;
    } else if (stage == 1) {
      if (servos[0].moving || servos[5].moving) {return false;}
      servos[0].gotoSmooth(45);
      servos[5].gotoSmooth(35);
      servos[4].gotoSmooth(15);
      servos[1].gotoSmooth(40);
      stage++;
      return false;
    } else if (stage == 2) {
      if (servos[5].moving || servos[1].moving || servos[0].moving || servos[4].moving) {return false;}
      servos[2].gotoSmooth(15);
      servos[3].gotoSmooth(15);
      stage++;
      return false;
    } else if (stage == 3) {
      if (servos[2].moving || servos[3].moving) {return false;}
      servos[5].gotoSmooth(45);
      servos[0].gotoSmooth(30);
      servos[4].gotoSmooth(-20);
      stage++;
      return false;
    } else if (stage == 4) {
      if (servos[0].moving || servos[4].moving || servos[5].moving) {return false;}
      servos[0].gotoSmooth(0);
      servos[5].gotoSmooth(0);
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      stage++;
      return false;
    } else if (stage == 5) {
      // NEXT STEP=====================================================
      if (servos[0].moving || servos[5].moving || servos[1].moving || servos[4].moving) {return false;}
      // Shifting to left side
      servos[0].gotoSmooth(-20);
      servos[5].gotoSmooth(-20);
      stage++;
      return false;
    } else if (stage == 6) {
      if (servos[0].moving || servos[5].moving) {return false;}
      // tilting to the right the rest of the way
      servos[5].gotoSmooth(-45);
      servos[0].gotoSmooth(-35);
      // lifting left foot
      servos[1].gotoSmooth(-15);
      servos[4].gotoSmooth(-40);
      stage++;
      return false;
    } else if (stage == 7) {
      if (servos[5].moving || servos[1].moving || servos[0].moving || servos[4].moving) {return false;}
      // shift over
      servos[2].gotoSmooth(-15);
      servos[3].gotoSmooth(-15);
      stage++;
      return false;
    } else if (stage == 8) {
      if (servos[2].moving || servos[3].moving) {return false;}
      servos[0].gotoSmooth(-45);
      servos[5].gotoSmooth(-30);
      servos[1].gotoSmooth(20);
      stage++;
      return false;
    } else if (stage == 9) {
      if (servos[0].moving || servos[1].moving || servos[5].moving) {return false;}
      // Making the robot upright again
      servos[0].gotoSmooth(0);
      servos[5].gotoSmooth(0);
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      
      stage = 0;
      return true;
    } 
    return true;
  }
  
  // if the foot is 
  void forward_to_reset() {
    if (move_in_progress) {
      // there's another move in progress
      println("Must wait to move until another move has finished!");
      return;
    }

    if (!previous_state.equals(states[3])) {
      println("Can't do this unless the left foot is in front!");
      return;
    }
    
    move_in_progress = true;
    println("Setting legs beside each other.");
    
    state = states[0]; 
    boolean done = false;
    int i = stage = 0;
    while(!done && i < 1000) {
      //println("At stage: "+stage);
      i++;
      done = forward_to_reset_aux();
      update();
    }
    if (i >= 1000) {
      println("failed");
    }
    stage = 0;
    previous_state = state;
    move_in_progress = false;
    return;
  }
  boolean forward_to_reset_aux() {
    if (stage == 0) {
      // tilt over
      servos[0].gotoSmooth(20);
      servos[5].gotoSmooth(20);
      stage++;
      return false;
    } else if (stage == 1) {
      if (servos[0].moving || servos[5].moving) {return false;}
      servos[0].gotoSmooth(45);
      servos[5].gotoSmooth(35);
      servos[4].gotoSmooth(15);
      servos[1].gotoSmooth(40);
      stage++;
      return false;
    } else if (stage == 2) {
      if (servos[5].moving || servos[1].moving || servos[0].moving || servos[4].moving) {return false;}
      servos[2].gotoSmooth(0);
      servos[3].gotoSmooth(0);
      stage++;
      return false;
    } else if (stage == 3) {
      if (servos[2].moving || servos[3].moving) {return false;}
      servos[0].gotoSmooth(0);
      servos[5].gotoSmooth(30);
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      stage++;
      return false;
    } else if (stage == 4) {
      if (servos[0].moving || servos[1].moving || servos[4].moving || servos[5].moving) {return false;}
      servos[5].gotoSmooth(0);
      return true;
    }
    
    return true;
  }
  
  void turn_right() {
    if (move_in_progress) {
      // there's another move in progress
      println("Must wait to move until another move has finished!");
      return;
    }

    if (!previous_state.equals(states[0])) {
      println("Can't do this unless the feet are parallell!");
      return;
    }
    
    move_in_progress = true;

    state = states[0]; 
    boolean done = false;
    int i = stage = 0;
    while(!done && i < 1000) {
      //println("At stage: "+stage);
      i++;
      done = turn_right_aux();
      update();
    }
    if (i >= 1000) {
      println("failed");
    }
    stage = 0;
    previous_state = state;
    move_in_progress = false;
    return;
  }
  
  boolean turn_right_aux() {
    if (stage == 0) {
      // tilt over
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      stage++;
      return false;
    } else if (stage == 1) {
      if (servos[1].moving || servos[4].moving) {return false;}
      servos[0].gotoSmooth(30);
      servos[5].gotoSmooth(30);
      stage++;
      return false;
    } else if (stage == 2) {
      if (servos[0].moving || servos[5].moving) {return false;}
      // tilt over the rest of the way
      servos[0].gotoSmooth(45);
      // lift left foott
      servos[4].gotoSmooth(15);      
      stage++;
      return false;
    } else if (stage == 3) {
      if (servos[0].moving || servos[4].moving) {return false;}
      //move out
      servos[2].gotoSmooth(-20);
      servos[3].gotoSmooth(20);
      stage++;
      return false;
    } else if (stage == 4) {
      if (servos[2].moving || servos[3].moving) {return false;}
      // setting foot down
      servos[4].gotoSmooth(-25);
      servos[0].gotoSmooth(0);
      servos[5].gotoSmooth(0);
      stage++;
      return false;
    } else if (stage == 5) {
      if (servos[0].moving || servos[4].moving || servos[5].moving) {return false;}
      servos[5].gotoSmooth(-45);
      servos[0].gotoSmooth(-30);
      servos[1].gotoSmooth(-15);
      servos[2].gotoSmooth(0);
      servos[3].gotoSmooth(0);
      stage++;
      return false;
    } else if (stage == 6) {
      if (servos[0].moving || servos[1].moving || servos[2].moving || servos[3].moving || servos[5].moving) {return false;}
      servos[5].gotoSmooth(0);
      servos[1].gotoSmooth(25);
      stage++;
      return false;
    } else if (stage == 7) {
      if (servos[5].moving || servos[1].moving) {return false;}
      servos[0].gotoSmooth(0);
      return true;
    }
    return true;
  }
  
  void turn_left() {
    if (move_in_progress) {
      // there's another move in progress
      println("Must wait to move until another move has finished!");
      return;
    }

    if (!previous_state.equals(states[0])) {
      println("Can't do this unless the feet are parallell!");
      return;
    }
    move_in_progress = true;
    
    state = states[0]; 
    boolean done = false;
    int i = stage = 0;
    while(!done && i < 1000) {
      //println("At stage: "+stage);
      i++;
      done = turn_left_aux();
      update();
    }
    if (i >= 1000) {
      println("failed");
    }
    stage = 0;
    previous_state = state;
    move_in_progress = false;
    return;
  }
  
  boolean turn_left_aux() {
    if (stage == 0) {
      // tilt over
      servos[1].gotoSmooth(25);
      servos[4].gotoSmooth(-25);
      stage++;
      return false;
    } else if (stage == 1) {
      if (servos[1].moving || servos[4].moving) {return false;}
      servos[0].gotoSmooth(-30);
      servos[5].gotoSmooth(-30);
      stage++;
      return false;
    } else if (stage == 2) {
      if (servos[0].moving || servos[5].moving) {return false;}
      // tilt over the rest of the way
      servos[5].gotoSmooth(-45);
      // lift left foott
      servos[1].gotoSmooth(-15);      
      stage++;
      return false;
    } else if (stage == 3) {
      if (servos[1].moving || servos[5].moving) {return false;}
      //move out
      servos[2].gotoSmooth(-20);
      servos[3].gotoSmooth(20);
      stage++;
      return false;
    } else if (stage == 4) {
      if (servos[2].moving || servos[3].moving) {return false;}
      // setting foot down
      servos[1].gotoSmooth(25);
      servos[0].gotoSmooth(0);
      servos[5].gotoSmooth(0);
      stage++;
      return false;
    } else if (stage == 5) {
      if (servos[1].moving || servos[4].moving || servos[5].moving) {return false;}
      servos[0].gotoSmooth(45);
      servos[5].gotoSmooth(30);
      servos[4].gotoSmooth(15);
      servos[2].gotoSmooth(0);
      servos[3].gotoSmooth(0);
      stage++;
      return false;
    } else if (stage == 6) {
      if (servos[0].moving || servos[5].moving || servos[4].moving || servos[2].moving || servos[3].moving ) {return false;}
      servos[4].gotoSmooth(-25);
      servos[0].gotoSmooth(0);
      stage++;
      return false;
    } else if (stage == 7) {
      if (servos[4].moving || servos[0].moving) {return false;}
      servos[5].gotoSmooth(0);
      stage++;
      return true;
    } 
    return true;
  }
  
  void tilt_other() {
    servos[0].gotoSmooth(-30);
    servos[5].gotoSmooth(-30);
  }
  
  void update() {
    // moving the servos
    for (int i = 0; i < servos.length; i++) {
      servos[i].update();
    }
    // wait 40 ms so things go smooth
    delay(40);
  }
}
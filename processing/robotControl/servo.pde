class Servo {
  int id, curr_pos, goal_pos;
  boolean moving = false;
  
  Servo(int id_) {
    id = id_;
    curr_pos = goal_pos = 151; // we don't know if this is true, so we set it to an invalid position
    moving = false;
  }
  
  void reset() {
    curr_pos = goal_pos = 512;
    moving = false;
  }
  
  void gotoSmooth(int angle) {
    goal_pos = floor((150 + angle) * 1024/300);
    //println("ID: "+id+"======== NEW ANGLE: "+goal_pos);
    //println("Goal angle: "+(150+angle)+"\nGoal position: "+goal_pos+"\t"+curr_pos);
    moving = true;  
  }
  
  void update() {
    if (curr_pos == goal_pos) {
      moving = false;
      return;
    }
    //println("ID: "+id+"\t"+goal_pos+"\t"+curr_pos);
    // calculate next increment:
    int steps_to_move = floor(sqrt(abs(goal_pos - curr_pos)));
    //println("Moving servo "+id+" from position "+curr_pos+" to pos "+goal_pos);
    int gotoPos = 512;
    if (goal_pos > curr_pos) {
      gotoPos = curr_pos + steps_to_move;
      curr_pos = gotoPos;
    } else {
      gotoPos = curr_pos - steps_to_move;
      curr_pos = gotoPos;
    }
    setReg2(id, 30, gotoPos);
  }
}
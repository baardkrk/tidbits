/*********
 * CW is positive
 * 0 is 150
 */
void gotoAngle(int id, int angle) {
  // convert form angle to position
  int gotoPos = floor((150 - angle) * magic);
  
  setReg2(id, 30, gotoPos);
}
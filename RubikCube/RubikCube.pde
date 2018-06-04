import frames.input.*;
import frames.core.*;
import frames.primitives.*;
import frames.processing.*;


Scene sceneCube, sceneFace4, sceneFace5, sceneFace6;
PGraphics canvasCube, canvasFace4, canvasFace5, canvasFace6;
Frame frame1, frame2, frame3, frame4, frame5, frame6, eye;
String renderer = P3D;
int w = 1024;
int h = 640;
int sizeOfCube = 15;
boolean rotateFrame = false;
int[] aux = {-2,0,2};

ArrayList<Cube> cubes = new ArrayList<Cube>();

ArrayList<Integer> cubesOnFrame1 = new ArrayList<Integer>(9);
ArrayList<Integer> cubesOnFrame2 = new ArrayList<Integer>(9);
ArrayList<Integer> cubesOnFrame3 = new ArrayList<Integer>(9);
ArrayList<Integer> cubesOnFrame4 = new ArrayList<Integer>(9);
ArrayList<Integer> cubesOnFrame5 = new ArrayList<Integer>(9);
ArrayList<Integer> cubesOnFrame6 = new ArrayList<Integer>(9);

void setup() {
  size(1024, 640, renderer);
    canvasCube = createGraphics(w/2, h / 2, P3D);
    sceneCube = new Scene(this, canvasCube);
    sceneCube.enableBoundaryEquations();
    OrbitShape eye = new OrbitShape(sceneCube);
    
    frame1 = new Frame(new Vector(0,0,-sizeOfCube), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    frame2 = new Frame(new Vector(0,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    frame3 = new Frame(new Vector(0,0,-sizeOfCube*5), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    frame4 = new Frame(new Vector(sizeOfCube*2,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    frame5 = new Frame(new Vector(0,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    frame6 = new Frame(new Vector(-sizeOfCube*2,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    
    sceneCube.setEye(eye);
    sceneCube.setDefaultGrabber(eye);
    sceneCube.setFieldOfView(PI / 3);
    sceneCube.fitBallInterpolation();
    
    canvasFace4 = createGraphics(w/2, h / 2, P3D);
    sceneFace4 = new Scene(this, canvasFace4,0, h/2);
    sceneFace4.setType(Graph.Type.ORTHOGRAPHIC);
    OrbitShape canvasFace4 = new OrbitShape(sceneFace4);
    sceneFace4.setEye(canvasFace4);
    sceneFace4.setDefaultGrabber(canvasFace4);
    sceneFace4.setRadius(200);
    sceneCube.setFieldOfView(PI / 3);
    sceneFace4.fitBall();
    
    canvasFace5 = createGraphics(w/2, h / 2, P3D);
    sceneFace5 = new Scene(this, canvasFace5,w/2, 0);
    sceneFace5.setType(Graph.Type.ORTHOGRAPHIC);
    OrbitShape canvasFace5 = new OrbitShape(sceneFace4);
    sceneFace5.setEye(canvasFace4);
    sceneFace5.setDefaultGrabber(canvasFace5);
    sceneFace5.setRadius(200);
    sceneCube.setFieldOfView(PI / 3);
    sceneFace4.fitBall();
    
    canvasFace6 = createGraphics(w/2, h / 2, P3D);
    sceneFace6 = new Scene(this, canvasFace6,w/2, h/2);
    sceneFace6.setType(Graph.Type.ORTHOGRAPHIC);
    OrbitShape canvasFace6 = new OrbitShape(sceneFace6);
    sceneFace6.setEye(canvasFace4);
    sceneFace6.setDefaultGrabber(canvasFace6);
    sceneFace6.setRadius(200);
    sceneCube.setFieldOfView(PI / 3);
    sceneFace4.fitBall();
     
     //Create cube list
    for(int i = 0; i < 27; i++){
        cubes.add(new Cube(sizeOfCube,i));
        if (i < 9) 
            cubesOnFrame1.add(i);
        else if( i<18)
            cubesOnFrame2.add(i);
        else
            cubesOnFrame3.add(i);
    }
    for( int i = 8; i >5; i--)
        cubesOnFrame4.add(cubesOnFrame1.get(i));
    for( int i = 8; i >5; i--)
        cubesOnFrame4.add(cubesOnFrame2.get(i));
    for( int i = 8; i >5; i--)
        cubesOnFrame4.add(cubesOnFrame3.get(i));
    println(cubesOnFrame4.size());
}

void draw() {
    background(0);
    println("Size array: "+cubes.size());
    sceneCube.beginDraw();
    canvasCube.background(0);
    sceneCube.drawAxes();
    DrawRubik1();
    sceneCube.endDraw();
    sceneCube.display();

    sceneFace4.beginDraw();
    canvasFace4.background(255);
    sceneFace4.endDraw();
    sceneFace4.display();

    sceneFace5.beginDraw();
    canvasFace5.background(255);
    sceneFace5.endDraw();
    sceneFace5.display();

    sceneFace6.beginDraw();
    canvasFace6.background(255);
    sceneFace6.endDraw();
    sceneFace6.display();
}


void rotateFrame(Frame frame,char direction){
    rotateFrame = true;
    if( rotateFrame ){
        canvasCube.pushMatrix();
        sceneCube.applyTransformation(frame);
        if( frame.equals(this.frame1) | frame.equals(this.frame2) | frame.equals(this.frame3)){
            if(direction == 'r')
                frame.rotate(new Quaternion(new Vector(0,0,1),PI/2));
            else if(direction == 'l')
                frame.rotate(new Quaternion(new Vector(0,0,1),-PI/2));
        }else{
            DrawRubik2();
            if(direction == 'r')
                frame.rotate(new Quaternion(new Vector(1,0,0),PI/2));
            else if(direction == 'l')
                frame.rotate(new Quaternion(new Vector(1,0,0),-PI/2));
        }
        canvasCube.popMatrix();
        rotateFrame = false;
    }
}

void DrawRubik1(){
       /*
     * Frame 1 
    */
    //canvasCube.background(0);
    int count = 0;
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(frame1);
    sceneCube.drawAxes(sizeOfCube);

    for( int id : cubesOnFrame1){
        canvasCube.pushMatrix();
        if( count < 3)
            canvasCube.translate(sizeOfCube*aux[0],sizeOfCube*aux[count], 0);
        else if( count > 2 & count < 6)
            canvasCube.translate(sizeOfCube*aux[1], sizeOfCube*aux[count%3], 0);
        else
            canvasCube.translate(sizeOfCube*aux[2], sizeOfCube*aux[count%3], 0);
        canvasCube.shape(cubes.get(id).getCube(),0, 0);
        canvasCube.popMatrix();
        count++;
    }
    canvasCube.popMatrix();

    /*
     * Frame 2 
    */
    count = 0;
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(frame2);
    sceneCube.drawAxes(10);
    for( int id : cubesOnFrame2){
        canvasCube.pushMatrix();
        if( count < 3)
            canvasCube.translate(sizeOfCube*aux[0],sizeOfCube*aux[count%3], 0);
        else if( count > 2 & count < 6)
            canvasCube.translate(sizeOfCube*aux[1], sizeOfCube*aux[count%3], 0);
        else
            canvasCube.translate(sizeOfCube*aux[2], sizeOfCube*aux[count%3], 0);
        canvasCube.shape(cubes.get(id).getCube(),0, 0);
        canvasCube.popMatrix();
        count++;
    }
    
    canvasCube.popMatrix(); 
    /*
     * Frame 3
    */
    count = 0;
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(frame3);
    sceneCube.drawAxes(10);
    for( int id : cubesOnFrame3){
        canvasCube.pushMatrix();
        if( count < 3)
            canvasCube.translate(sizeOfCube*aux[0],sizeOfCube*aux[count%3], 0);
        else if( count > 2 & count < 6)
            canvasCube.translate(sizeOfCube*aux[1], sizeOfCube*aux[count%3], 0);
        else
            canvasCube.translate(sizeOfCube*aux[2], sizeOfCube*aux[count%3], 0);
        canvasCube.shape(cubes.get(id).getCube(),0, 0);
        canvasCube.popMatrix();
        count++;
    }
    canvasCube.popMatrix(); 

}

void DrawRubik2(){
    canvasCube.clear();

    /*
     * Frame 4
    */
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(frame4);
    sceneCube.drawAxes(10);
    canvasCube.popMatrix();

    /*
     * Frame 5
    */
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(frame5);
    sceneCube.drawAxes(10);
    canvasCube.popMatrix();

    /*
     * Frame 6
    */
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(frame6);
    sceneCube.drawAxes(10);
    canvasCube.popMatrix();

}


void keyPressed() {
    if(key == '1')
        rotateFrame(frame1,'r');
    if(key == '7')
        rotateFrame(frame1,'l');
    if(key == '2')
        rotateFrame(frame2, 'r');
    if(key == '8')
        rotateFrame(frame2, 'l');
    if(key == '3')
        rotateFrame(frame3, 'r');
    if(key == '9')
        rotateFrame(frame3, 'l');

    if(key == '4')
        rotateFrame(frame4,'r');
    // if(key == '10')
    //     rotateFrame(frame4,'l');
    if(key == '5')
        rotateFrame(frame5, 'r');
    // if(key == '11')
    //     rotateFrame(frame5, 'l');
    if(key == '6')
        rotateFrame(frame6, 'r');
    // if(key == '12')
    //     rotateFrame(frame6, 'l');
        
}

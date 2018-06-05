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
int numRotationsFrame1  = 0;
int numRotationsFrame2 = 0;
int numRotationsFrame3 = 0;
boolean rotateFrame = false;
int[] aux = {-2,0,2};
OctreeNode root;

ArrayList<Cube> cubes = new ArrayList<Cube>();
ArrayList<Frame> framesOfOne = new ArrayList<Frame>(9);
ArrayList<Frame> framesOfTwo = new ArrayList<Frame>(9);
ArrayList<Frame> framesOfThree = new ArrayList<Frame>(9);

ArrayList<Vector> idFramesOne = new ArrayList<Vector>(6);
ArrayList<Vector> idFramesTwo = new ArrayList<Vector>(6);
ArrayList<Vector> idFramesThree = new ArrayList<Vector>(6);

void setup() {
  size(1024, 640, renderer);
    canvasCube = createGraphics(w/2, h / 2, P3D);
    sceneCube = new Scene(this, canvasCube);
    sceneCube.enableBoundaryEquations();
    OrbitShape eye = new OrbitShape(sceneCube);
    // declare and build the octree hierarchy
    Vector p = new Vector(100, 70, 130);
    root = new OctreeNode(p, Vector.multiply(p, -1.0f));
    root.buildBoxHierarchy(4);

    frame1 = new Frame(new Vector(0,0,-sizeOfCube), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    frame2 = new Frame(new Vector(0,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    frame3 = new Frame(new Vector(0,0,-sizeOfCube*5), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    // frame4 = new Frame(new Vector(sizeOfCube*2,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    // frame5 = new Frame(new Vector(0,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));
    // frame6 = new Frame(new Vector(-sizeOfCube*2,0,-sizeOfCube*3), new Quaternion(new Vector(0,1,0), new Vector(0,0,0)));

    /*
            TESTING :v
    */
    // n1ewFrame = new Frame();
    // newFrame.setReference(frame1);
    // newFrame.setTranslation(sizeOfCube*aux[0],sizeOfCube*aux[0],0 );
    
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
    for(int i = 0; i < 1; i++)
        cubes.add(new Cube(sizeOfCube,i));


    addFrames( framesOfOne , frame1);
    addFrames( framesOfTwo , frame2);
    addFrames( framesOfThree , frame3);

    idFramesOne.add(new Vector(0,1,2));
    idFramesOne.add(new Vector(2,5,8));
    idFramesOne.add(new Vector(6,7,8));
    idFramesOne.add(new Vector(0,3,6));
    idFramesOne.add(new Vector(3,4,5));
    idFramesOne.add(new Vector(1,4,7));

}

void draw() {
    background(0);
    sceneCube.beginDraw();
    canvasCube.background(0);
    sceneCube.drawAxes();
    DrawRubik(frame1,frame2, frame3);
    sceneCube.endDraw();
    sceneCube.display();

    sceneFace4.beginDraw();
    canvasFace4.background(0);
    root.drawIfAllChildrenAreVisible(sceneFace4.frontBuffer(), sceneCube);
    sceneFace4.drawEye(sceneCube);
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


void rotateFrame(Frame frame,char direction, Vector axis){
    rotateFrame = true;
    if( rotateFrame ){
        canvasCube.pushMatrix();
        sceneCube.applyTransformation(frame);
        if( frame.equals(this.frame1) | frame.equals(this.frame2) | frame.equals(this.frame3)){
            if(direction == 'r')
                frame.rotate(new Quaternion(axis,PI/2));
            else if(direction == 'l')
                frame.rotate(new Quaternion(axis,-PI/2));
        }else{
            if(direction == 'r')
                frame.rotate(new Quaternion(axis,PI/2));
            else if(direction == 'l')
                frame.rotate(new Quaternion(axis,-PI/2));
        }
        canvasCube.popMatrix();
        rotateFrame = false;
    }
}

void addFrames(ArrayList<Frame> frameList ,Frame frame){
        for( int count = 0; count < 9; count++){
        if( count < 3)
            frameList.add(new Frame(
                                    frame,
                                    new Vector(sizeOfCube*aux[0],sizeOfCube*aux[count], 0),
                                    new Quaternion()
                                    )
            );
        else if( count > 2 & count < 6)
            frameList.add(new Frame(
                                    frame,
                                    new Vector(sizeOfCube*aux[1], sizeOfCube*aux[count%3], 0), 
                                    new Quaternion()
                                    )
            );
        else
            frameList.add(new Frame(
                                    frame, 
                                    new Vector(sizeOfCube*aux[2], sizeOfCube*aux[count%3], 0),
                                    new Quaternion()
                                    )
            );
    }
}
void DrawRubik(Frame fisrtFrame, Frame secondFrame, Frame thirdFrame){
    /*
    **********************************
                 Frame 1 
    **********************************
    */
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(fisrtFrame);
    sceneCube.drawAxes(sizeOfCube);
    
    for( Frame frame : framesOfOne){
        canvasCube.pushMatrix();
        sceneCube.applyTransformation(frame);
        sceneCube.drawAxes(sizeOfCube);
        canvasCube.shape(cubes.get(0).getCube());
        canvasCube.popMatrix();
    }
    canvasCube.popMatrix();
    /*
    **********************************
                 Frame 2 
    **********************************
    */
    canvasCube.pushMatrix();
    sceneCube.applyTransformation(secondFrame);
    sceneCube.drawAxes(10);
    
    for( Frame frame2 : framesOfTwo){
        canvasCube.pushMatrix();
        sceneCube.applyTransformation(frame2);
        sceneCube.drawAxes(sizeOfCube);
        canvasCube.shape(cubes.get(0).getCube());
        canvasCube.popMatrix();
    }
    canvasCube.popMatrix(); 
    /*
    **********************************
                 Frame 3 
    **********************************
    */

    canvasCube.pushMatrix();
    sceneCube.applyTransformation(thirdFrame);
    sceneCube.drawAxes(10);
    for( Frame frame3 : framesOfThree){
        canvasCube.pushMatrix();
        sceneCube.applyTransformation(frame3);
        sceneCube.drawAxes(sizeOfCube);
        canvasCube.shape(cubes.get(0).getCube());
        canvasCube.popMatrix();
    }
    canvasCube.popMatrix(); 

}

void keyPressed() {
    if(key == '1'){
        rotateFrame(frame1,'r',new Vector(0,0,1));
        numRotationsFrame1 = (numRotationsFrame1+1)%4;    }
    if(key == '7'){
        rotateFrame(frame1,'l', new Vector(0,0,1));
        numRotationsFrame1 = Math.floorMod(numRotationsFrame1-1,4);
    }
    if(key == '2'){
        rotateFrame(frame2, 'r',new Vector(0,0,1));
        numRotationsFrame2 = (numRotationsFrame2+1)%4;
    }
    if(key == '8'){
        rotateFrame(frame2, 'l',new Vector(0,0,1));
        numRotationsFrame2 = Math.floorMod(numRotationsFrame2-1,4);
    }
    if(key == '3'){
        rotateFrame(frame3, 'r',new Vector(0,0,1));
        numRotationsFrame3 = (numRotationsFrame3+1)%4;
    }
    if(key == '9'){
        rotateFrame(frame3, 'l',new Vector(0,0,1));
        numRotationsFrame3 = Math.floorMod(numRotationsFrame3-1,4);
    }
    if(key == '4'){
        switch (numRotationsFrame1) {
            case 0:
                int[] id = {int(idFramesOne.get(0).x()), int(idFramesOne.get(0).y()), int(idFramesOne.get(0).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id[i]),'r',new Vector(1,0,0));
                }
                break;
            case 1:
                int[] id1 = {int(idFramesOne.get(1).x()), int(idFramesOne.get(1).y()), int(idFramesOne.get(1).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id1[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfTwo.get(id1[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfThree.get(id1[i]),'r',new Vector(0,-1,0));
                }
                break;
            case 2:
                int[] id2 = {int(idFramesOne.get(2).x()), int(idFramesOne.get(2).y()), int(idFramesOne.get(2).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id2[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfTwo.get(id2[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfThree.get(id2[i]),'r',new Vector(-1,0,0));
                }
                break;
            case 3:
                int[] id3 = {int(idFramesOne.get(3).x()), int(idFramesOne.get(3).y()), int(idFramesOne.get(3).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id3[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfTwo.get(id3[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfThree.get(id3[i]),'r',new Vector(0,1,0));
                }
                break;
        }
    }
    // if(key == '10')
    //     rotateFrame(frame4,'l');
    if(key == '5'){
        switch (numRotationsFrame1) {
            case 0:
                int[] id = {int(idFramesOne.get(4).x()), int(idFramesOne.get(4).y()), int(idFramesOne.get(4).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id[i]),'r',new Vector(1,0,0));
                }
                break;
            case 1:
                int[] id2 = {int(idFramesOne.get(5).x()), int(idFramesOne.get(5).y()), int(idFramesOne.get(5).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id2[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfTwo.get(id2[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfThree.get(id2[i]),'r',new Vector(0,1,0));
                }
                break;
            case 2:
                int[] id3 = {int(idFramesOne.get(4).x()), int(idFramesOne.get(4).y()), int(idFramesOne.get(4).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id3[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id3[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id3[i]),'r',new Vector(1,0,0));
                }
                break;
            case 3:
                int[] id4 = {int(idFramesOne.get(5).x()), int(idFramesOne.get(5).y()), int(idFramesOne.get(5).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id4[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfTwo.get(id4[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfThree.get(id4[i]),'r',new Vector(0,1,0));
                }
                break;
        }
    }
    // if(key == '11')
    //     rotateFrame(frame5, 'l');
    if(key == '6'){
        switch (numRotationsFrame1) {
            case 0:
                int[] id2 = {int(idFramesOne.get(2).x()), int(idFramesOne.get(2).y()), int(idFramesOne.get(2).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id2[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id2[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id2[i]),'r',new Vector(1,0,0));
                }
                break;
            case 1:
                int[] id3 = {int(idFramesOne.get(3).x()), int(idFramesOne.get(3).y()), int(idFramesOne.get(3).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id3[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfTwo.get(id3[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfThree.get(id3[i]),'r',new Vector(0,-1,0));
                }
                break;
            case 2:
                int[] id = {int(idFramesOne.get(0).x()), int(idFramesOne.get(0).y()), int(idFramesOne.get(0).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfTwo.get(id[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfThree.get(id[i]),'r',new Vector(-1,0,0));
                }
                break;
            case 3:
                int[] id1 = {int(idFramesOne.get(1).x()), int(idFramesOne.get(1).y()), int(idFramesOne.get(1).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id1[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfTwo.get(id1[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfThree.get(id1[i]),'r',new Vector(0,1,0));
                }
                break;
        }
    }
}

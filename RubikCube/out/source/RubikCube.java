import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import frames.input.*; 
import frames.core.*; 
import frames.primitives.*; 
import frames.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RubikCube extends PApplet {







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

public void setup() {
  
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

public void draw() {
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


public void rotateFrame(Frame frame,char direction, Vector axis){
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

public void addFrames(ArrayList<Frame> frameList ,Frame frame){
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
public void DrawRubik(Frame fisrtFrame, Frame secondFrame, Frame thirdFrame){
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

public void keyPressed() {
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
                int[] id = {PApplet.parseInt(idFramesOne.get(0).x()), PApplet.parseInt(idFramesOne.get(0).y()), PApplet.parseInt(idFramesOne.get(0).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id[i]),'r',new Vector(1,0,0));
                }
                break;
            case 1:
                int[] id1 = {PApplet.parseInt(idFramesOne.get(1).x()), PApplet.parseInt(idFramesOne.get(1).y()), PApplet.parseInt(idFramesOne.get(1).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id1[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfTwo.get(id1[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfThree.get(id1[i]),'r',new Vector(0,-1,0));
                }
                break;
            case 2:
                int[] id2 = {PApplet.parseInt(idFramesOne.get(2).x()), PApplet.parseInt(idFramesOne.get(2).y()), PApplet.parseInt(idFramesOne.get(2).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id2[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfTwo.get(id2[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfThree.get(id2[i]),'r',new Vector(-1,0,0));
                }
                break;
            case 3:
                int[] id3 = {PApplet.parseInt(idFramesOne.get(3).x()), PApplet.parseInt(idFramesOne.get(3).y()), PApplet.parseInt(idFramesOne.get(3).z()) };
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
                int[] id = {PApplet.parseInt(idFramesOne.get(4).x()), PApplet.parseInt(idFramesOne.get(4).y()), PApplet.parseInt(idFramesOne.get(4).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id[i]),'r',new Vector(1,0,0));
                }
                break;
            case 1:
                int[] id2 = {PApplet.parseInt(idFramesOne.get(5).x()), PApplet.parseInt(idFramesOne.get(5).y()), PApplet.parseInt(idFramesOne.get(5).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id2[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfTwo.get(id2[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfThree.get(id2[i]),'r',new Vector(0,1,0));
                }
                break;
            case 2:
                int[] id3 = {PApplet.parseInt(idFramesOne.get(4).x()), PApplet.parseInt(idFramesOne.get(4).y()), PApplet.parseInt(idFramesOne.get(4).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id3[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id3[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id3[i]),'r',new Vector(1,0,0));
                }
                break;
            case 3:
                int[] id4 = {PApplet.parseInt(idFramesOne.get(5).x()), PApplet.parseInt(idFramesOne.get(5).y()), PApplet.parseInt(idFramesOne.get(5).z()) };
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
                int[] id2 = {PApplet.parseInt(idFramesOne.get(2).x()), PApplet.parseInt(idFramesOne.get(2).y()), PApplet.parseInt(idFramesOne.get(2).z()) };
                for( int i = 0; i<3; i++){
                    rotateFrame(framesOfOne.get(id2[i]),'r', new Vector(1,0,0));
                    rotateFrame(framesOfTwo.get(id2[i]),'r',new Vector(1,0,0));
                    rotateFrame(framesOfThree.get(id2[i]),'r',new Vector(1,0,0));
                }
                break;
            case 1:
                int[] id3 = {PApplet.parseInt(idFramesOne.get(3).x()), PApplet.parseInt(idFramesOne.get(3).y()), PApplet.parseInt(idFramesOne.get(3).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id3[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfTwo.get(id3[i]),'r',new Vector(0,-1,0));
                    rotateFrame(framesOfThree.get(id3[i]),'r',new Vector(0,-1,0));
                }
                break;
            case 2:
                int[] id = {PApplet.parseInt(idFramesOne.get(0).x()), PApplet.parseInt(idFramesOne.get(0).y()), PApplet.parseInt(idFramesOne.get(0).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfTwo.get(id[i]),'r',new Vector(-1,0,0));
                    rotateFrame(framesOfThree.get(id[i]),'r',new Vector(-1,0,0));
                }
                break;
            case 3:
                int[] id1 = {PApplet.parseInt(idFramesOne.get(1).x()), PApplet.parseInt(idFramesOne.get(1).y()), PApplet.parseInt(idFramesOne.get(1).z()) };
                for( int i = 0; i < 3; i++){
                    rotateFrame(framesOfOne.get(id1[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfTwo.get(id1[i]),'r',new Vector(0,1,0));
                    rotateFrame(framesOfThree.get(id1[i]),'r',new Vector(0,1,0));
                }
                break;
        }
    }
}
class Cube{
    //Fields
    int size;
    int id;
    PShape cube;


    public Cube(int size, int id) {
        this.size = size;
        this.id = id;

        this.cube = new PShape();
        this.cube = createShape();
        cube.beginShape(QUADS);
        
        cube.fill(255,0,0);
        cube.vertex(-size,  size,  size);
        cube.vertex( size,  size,  size);
        cube.vertex( size, -size,  size);
        cube.vertex(-size, -size,  size);
        
        cube.fill(255,240,0);
        cube.vertex( size,  size,  size);
        cube.vertex( size,  size, -size);
        cube.vertex( size, -size, -size);
        cube.vertex( size, -size,  size);
        
        cube.fill(0,255,0);
        cube.vertex( size, size, -size);
        cube.vertex(-size,  size, -size);
        cube.vertex(-size, -size, -size);
        cube.vertex( size, -size, -size);
        
        cube.fill(0,0,255);
        cube.vertex(-size,  size, -size);
        cube.vertex(-size,  size,  size );
        cube.vertex(-size, -size,  size );
        cube.vertex(-size, -size, -size);
        
        cube.fill(255,255,255);
        cube.vertex(-size,  size, -size);
        cube.vertex( size,  size, -size);
        cube.vertex( size,  size, size );
        cube.vertex(-size,  size, size );
        
        cube.fill(148,11,223);
        cube.vertex(-size, -size, -size);
        cube.vertex( size, -size, -size);
        cube.vertex( size, -size,  size );
        cube.vertex(-size, -size,  size );
        cube.endShape();
    }

    public int getId(){
        return this.id;
    }

    public PShape getCube(){
        return this.cube;
    }
}
public class OctreeNode {
  Vector p1, p2;
  OctreeNode child[];
  int level;

  OctreeNode(Vector P1, Vector P2) {
    p1 = P1;
    p2 = P2;
    child = new OctreeNode[8];
  }

  public void draw(PGraphics pg) {
    pg.stroke(color(0.3f * level * 255, 0.2f * 255, (1.0f - 0.3f * level) * 255));
    pg.strokeWeight(level + 1);

    pg.beginShape();
    pg.vertex(p1.x(), p1.y(), p1.z());
    pg.vertex(p1.x(), p2.y(), p1.z());
    pg.vertex(p2.x(), p2.y(), p1.z());
    pg.vertex(p2.x(), p1.y(), p1.z());
    pg.vertex(p1.x(), p1.y(), p1.z());
    pg.vertex(p1.x(), p1.y(), p2.z());
    pg.vertex(p1.x(), p2.y(), p2.z());
    pg.vertex(p2.x(), p2.y(), p2.z());
    pg.vertex(p2.x(), p1.y(), p2.z());
    pg.vertex(p1.x(), p1.y(), p2.z());
    pg.endShape();

    pg.beginShape(PApplet.LINES);
    pg.vertex(p1.x(), p2.y(), p1.z());
    pg.vertex(p1.x(), p2.y(), p2.z());
    pg.vertex(p2.x(), p2.y(), p1.z());
    pg.vertex(p2.x(), p2.y(), p2.z());
    pg.vertex(p2.x(), p1.y(), p1.z());
    pg.vertex(p2.x(), p1.y(), p2.z());
    pg.endShape();
  }

  public void drawIfAllChildrenAreVisible(PGraphics pg, Graph camera) {
    Graph.Visibility vis = camera.boxVisibility(p1, p2);
    if (vis == Graph.Visibility.VISIBLE)
      draw(pg);
    else if (vis == Graph.Visibility.SEMIVISIBLE)
      if (child[0] != null)
        for (int i = 0; i < 8; ++i)
          child[i].drawIfAllChildrenAreVisible(pg, camera);
      else
        draw(pg);
  }

  public void buildBoxHierarchy(int l) {
    level = l;
    Vector middle = Vector.multiply(Vector.add(p1, p2), 1 / 2.0f);
    for (int i = 0; i < 8; ++i) {
      // point in one of the 8 box corners
      Vector point = new Vector(((i & 4) != 0) ? p1.x() : p2.x(), ((i & 2) != 0) ? p1.y() : p2.y(), ((i & 1) != 0) ? p1.z() : p2.z());
      if (level > 0) {
        child[i] = new OctreeNode(point, middle);
        child[i].buildBoxHierarchy(level - 1);
      } else
        child[i] = null;
    }
  }
}
/**
 * OrbitShape.
 * by Jean Pierre Charalambos.
 * 
 * This class implements a shape behavior which requires
 * overriding the interact(Event) method.
 *
 * Feel free to copy paste it.
 */

public class OrbitShape extends Shape {
  public OrbitShape(Scene scene) {
    super(scene);
  }
  
  public OrbitShape(Node node) {
    super(node);
  }

  // this one gotta be overridden because we want a copied node
  // to have the same behavior as its original.
  protected OrbitShape(Scene otherScene, OrbitShape otherShape) {
    super(otherScene, otherShape);
  }

  @Override
  public OrbitShape get() {
    return new OrbitShape(this.graph(), this);
  }

  // behavior is here :P
  @Override
  public void interact(frames.input.Event event) {
    if (event.shortcut().matches(new Shortcut(RIGHT)))
      translate(event);
    if (event.shortcut().matches(new Shortcut(LEFT)))
      rotate(event);
    if (event.shortcut().matches(new Shortcut(CENTER)))
      rotate(event);
    if (event.shortcut().matches(new Shortcut(processing.event.MouseEvent.WHEEL)))
      if (isEye() && graph().is3D())
        translateZ(event);
      else
        scale(event);
  }
}
  public void settings() {  size(1024, 640, renderer); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RubikCube" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

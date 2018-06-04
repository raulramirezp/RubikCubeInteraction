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

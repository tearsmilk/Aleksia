#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl> 

precision highp float;






#define hue(v)  ((.6+.6*cos(6.*(v)+vec4(0, 23, 21, 1)))+vec4(0., 0., 0., 1.) )

#define finalize() { vertexDistance=length((ModelViewMat*vertex).xyz); texCoord0=UV0; }

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;


uniform sampler2D Sampler0;

uniform sampler2D Sampler2;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;

float safeGameTime() {
    float gameTime=GameTime;
    
    if(gameTime <= 0) {
        gameTime=.5;
    }
    return gameTime;
}

float scaledTime() {
    return safeGameTime()*12000.;
}

void f_0(inout vec4 vertex) {
    gl_Position=ProjMat*ModelViewMat*vertex;
}

void f_1() {
    vertexColor=Color*texelFetch(Sampler2, UV2 / 16, 0);
}


void f_2(inout vec4 vertex) {
    f_0(vertex);
    if(Position.z==0. && gl_Position.x > .95) {
        vertexColor=vec4(0);
    }else{
        f_1();
    }
    finalize();
}



void f_3() {
    vertexColor=hue(gl_Position.x+safeGameTime()*1000.)*texelFetch(Sampler2, UV2 / 16, 0);
}

void f_4() {
    gl_Position.y+=sin(scaledTime()+(gl_Position.x*6)) / 150.;
}

void f_5(inout vec4 vertex) {
    f_0(vertex);
    f_3();
    finalize();
}

void f_6(inout vec4 vertex) {
    f_0(vertex);
    f_1();
    f_4();
    finalize();
}

void f_7(inout vec4 vertex) {
    f_0(vertex);
    f_4();
    f_3();
    finalize();
}

void f_8(inout vec4 vertex) {
    f_1();
    float vertexId=mod(gl_VertexID, 4.);
    if(vertex.z <= 0.) {
        if(vertexId==3. || vertexId==0.) {
            vertex.y+=cos(scaledTime() / 4)*.1;
            vertex.y+=max(cos(scaledTime() / 4)*.1, 0.);
        }
    }else{
        if(vertexId==3. || vertexId==0.) {
            vertex.y-=cos(scaledTime() / 4)*3;
            vertex.y-=max(cos(scaledTime() / 4)*4, 0.);
        }
    }
    f_0(vertex);
    finalize();
}

void f_9(inout vec4 vertex) {
    float vertexId=mod(gl_VertexID, 4.);
    if(vertex.z <= 0.) {
        if(vertexId==3. || vertexId==0.) {
            vertex.y+=cos(scaledTime() / 4)*.1;
            vertex.y+=max(cos(scaledTime() / 4)*.1, 0.);
        }
    }else{
        if(vertexId==3. || vertexId==0.) {
            vertex.y-=cos(scaledTime() / 4)*3;
            vertex.y-=max(cos(scaledTime() / 4)*4, 0.);
        }
    }
    f_3();
    f_0(vertex);
    finalize();
}

void f_a(inout vec4 vertex, float speed) {
    f_0(vertex);
    float blink=abs(sin(scaledTime()*speed));
    vertexColor=Color*blink*texelFetch(Sampler2, UV2 / 16, 0);
    finalize();
}



void f_b(inout vec4 vertex) {
    f_0(vertex);
    f_1();
    vertexColor=vec4(1, 1, 1, vertexColor.a); 
    finalize();
}


// creepers:flash — вершины с цветом #FEFEFD растягиваются на весь экран (белая вспышка).
// sphericalVertexDistance = -1 сообщает фрагментному шейдеру игнорировать текстуру глифа.
void f_flash(inout vec4 vertex) {
    f_0(vertex);
    float vid = mod(gl_VertexID, 4.);
    vec2 c = vec2(-1., 1.);
    if (vid == 1.) c = vec2(-1., -1.);
    else if (vid == 2.) c = vec2(1., -1.);
    else if (vid == 3.) c = vec2(1., 1.);
    gl_Position = vec4(c * gl_Position.w, gl_Position.z, gl_Position.w);
    vertexColor = vec4(1., 1., 1., Color.a);
    sphericalVertexDistance = -1.;
    cylindricalVertexDistance = -1.;
    texCoord0 = UV0;
    vertexDistance = 0.;
}

void main() {

    sphericalVertexDistance=fog_spherical_distance(Position);
    cylindricalVertexDistance=fog_cylindrical_distance(Position);
    vertexColor=Color*texelFetch(Sampler2, UV2 / 16, 0);

    vec4 vertex=vec4(Position, 1.);
    ivec3 iColor=ivec3(Color.xyz*255+vec3(.5));

    if(iColor==ivec3(254, 254, 253))
    {
        f_flash(vertex);
        return;
    }

    
    
    if(iColor==ivec3(255, 85, 85))
    {
        f_2(vertex);
        return;
    }
    

    
    if(fract(Position.z) < .1) {
        
        
        if(iColor==ivec3(19, 23, 9))
        {
            gl_Position=vec4(2, 2, 2, 1);
            f_1();
            finalize();
            return;
        }
        

        
        
        if(iColor==ivec3(57, 63, 63)) {
            
            
            f_0(vertex);
            f_1();
            finalize();
            return;
        }

        
        if(iColor==ivec3(57, 63, 62)) {
            f_6(vertex);
            return;
        }

        
        if(iColor==ivec3(57, 62, 63)) {
            
            f_6(vertex);
            return;
        }

        
        if(iColor==ivec3(57, 62, 62)) {
            f_8(vertex);
            return;
        }

        
        if(iColor==ivec3(57, 61, 63)) {
            f_8(vertex);
            return;
        }

        
        if(iColor==ivec3(57, 61, 62)) {
            f_a(vertex, .5);
            return;
        }

        

        
    }

    
    
    if(iColor==ivec3(78, 92, 36))
    {
        f_b(vertex);
        return;
    }
    

    
    
    
    if(iColor==ivec3(230, 255, 254))
    {
        f_5(vertex);
        return;
    }

    
    if(iColor==ivec3(230, 255, 250))
    {
        f_6(vertex);
        return;
    }

    
    if(iColor==ivec3(230, 251, 254))
    {
        f_7(vertex);
        return;
    }

    
    if(iColor==ivec3(230, 251, 250))
    {
        f_8(vertex);
        return;
    }

    
    if(iColor==ivec3(230, 247, 254))
    {
        f_9(vertex);
        return;
    }

    
    if(iColor==ivec3(230, 247, 250))
    {
        f_a(vertex, .5);
        return;
    }

    
    

    
    
    
    if(iColor==ivec3(255, 255, 254))
    {
        f_5(vertex);
        return;
    }

    
    if(iColor==ivec3(255, 255, 253))
    {
        f_6(vertex);
        return;
    }

    
    if(iColor==ivec3(255, 255, 25))
    {
        f_7(vertex);
        return;
    }

    
    if(iColor==ivec3(255, 255, 251))
    {
        f_8(vertex);
        return;
    }

    
    if(iColor==ivec3(255, 254, 254))
    {
        f_9(vertex);
        return;
    }
    

    
    f_0(vertex);
    f_1();
    finalize();
}
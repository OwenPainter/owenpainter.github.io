// =====================================================
// Sparse CGI Forest
// =====================================================

#version 3.7;

global_settings {
    assumed_gamma 1.0
}

#include "colors.inc"

// ---------------- CAMERA ----------------

camera {
    location <0, 5.0, -24> // Moves the camera up slight
    look_at <0, 2.0, 30>   // Tilts the camera downwards
    angle 68
}

// ---------------- LIGHTING ----------------

light_source {
    <0, 90, -60>
    color rgb <0.7, 0.85, 1.0>
}

light_source {
    <-40, 25, -10>
    color rgb <0.15, 0.35, 0.9>
}

// ---------------- SKY ----------------

sky_sphere {
    pigment {
        gradient y
        color_map {
            [0.0 color rgb <0.65, 0.82, 1.0>]
            [0.35 color rgb <0.22, 0.28, 0.5>]
            [0.7 color rgb <0.06, 0.08, 0.22>]
            [1.0 color rgb <0.01, 0.02, 0.08>]
        }
    }
}

// ---------------- GROUND ----------------

plane {
    y, 0
    texture {
        pigment {
            checker
            color rgb <0.03,0.10,0.05>,
            color rgb <0.05,0.16,0.07>

            // Diamond angle
            rotate <0,45,0>
            scale 4
        }
        finish {
            ambient 0.14
            diffuse 0.8
        }
    }
}

// ---------------- FOG ----------------

fog {
    distance 450 // Pushed back to reveal the mountain range
    color rgb <0.10,0.14,0.20>
}

// ---------------- BROWN BEAR ----------------
// vertically stretched bump map
#declare BearBrown = texture {
    pigment { color rgb <0.4, 0.22, 0.1> }
    normal { bumps 1.0 scale <0.05, 0.15, 0.05> } 
    finish { phong 0.1 diffuse 0.7 } // Lowered phong so it look fuzzy
}
#declare BearLight = texture {
    pigment { color rgb <0.7, 0.5, 0.3> }
    normal { bumps 1.0 scale <0.05, 0.15, 0.05> }
    finish { phong 0.1 diffuse 0.7 }
}
#declare BearBlack = texture {
    pigment { color rgb <0.05, 0.05, 0.05> }
    finish { phong 0.5 } // Keep the nose/eyes shiny
}

union {
    // Body
    sphere { <0, 2.5, 0>, 2 scale <1, 1.2, 1> texture { BearBrown } }
    // Belly patch
    sphere { <0, 2.3, -1.8>, 1.2 scale <1, 1.3, 0.5> texture { BearLight } }
    
    // Head
    sphere { <0, 5, 0>, 1.2 texture { BearBrown } }
    // Snout
    sphere { <0, 4.7, -1.1>, 0.6 texture { BearLight } }
    // Nose
    sphere { <0, 4.8, -1.65>, 0.2 texture { BearBlack } }
    
    // Ears
    sphere { <-0.8, 5.8, 0>, 0.4 texture { BearBrown } }
    sphere { <0.8, 5.8, 0>, 0.4 texture { BearBrown } }
    
    // Eyes
    sphere { <-0.4, 5.2, -1.05>, 0.15 texture { BearBlack } }
    sphere { <0.4, 5.2, -1.05>, 0.15 texture { BearBlack } }
    
    // Legs (Bottom)
    cylinder { <-0.8, 0.5, 0>, <-0.8, 1.5, 0>, 0.7 texture { BearBrown } }
    cylinder { <0.8, 0.5, 0>, <0.8, 1.5, 0>, 0.7 texture { BearBrown } }
    // Paws (Bottom)
    sphere { <-0.8, 0.5, -0.2>, 0.7 texture { BearBrown } }
    sphere { <0.8, 0.5, -0.2>, 0.7 texture { BearBrown } }

    // Right arm
    cylinder { <-1.2, 3.5, 0>, <-2.0, 1.5, -0.5>, 0.5 texture { BearBrown } }
    sphere { <-2.0, 1.5, -0.5>, 0.5 texture { BearBrown } }

    // Left arm
    cylinder { <1.2, 3.5, 0>, <2.0, 1.5, -0.5>, 0.5 texture { BearBrown } }
    sphere { <2.0, 1.5, -0.5>, 0.5 texture { BearBrown } }

    rotate <0, -25, 0> // Face slightly inward toward camera
    scale 0.85                
    translate <-8.5, 0.0, 2>
}


// ---------------- TREE MACRO ----------------

#macro RetroTree(PosX, PosZ, Height, Radius)

union {

    // ---------------- TRUNK ----------------

    cylinder {
        <0,0,0>,
        <0,Height,0>,
        Radius * 2 

        texture {
            pigment {
                color rgb <0.42,0.24,0.12>
            }
            finish {
                phong 0.15
            }
        }
    }

    // ---------------- LOWER SECTION ----------------
cone {
    <0, Height-5, 0>, Radius*7
    <0, Height+1, 0>, 0

    texture {
        pigment {
            granite
            color_map {
                [0.0 color rgb <0.0, 0.40, 0.15>] 
                [0.5 color rgb <0.0, 0.50, 0.22>] 
                [1.0 color rgb <0.10, 0.60, 0.30>] 
            }
            scale 0.1 
        }
        normal { granite 0.1 scale 0.05 }
        finish {
            phong 0.45
            reflection 0.03
        }
    }
}

// ---------------- MIDDLE SECTION ----------------
cone {
    <0, Height-1, 0>, Radius*5
    <0, Height+5, 0>, 0

    texture {
        pigment {
            granite
            color_map {
                [0.0 color rgb <0.0, 0.50, 0.20>] 
                [0.5 color rgb <0.0, 0.62, 0.28>] 
                [1.0 color rgb <0.10, 0.70, 0.35>] 
            }
            scale 0.1
        }
        normal { granite 0.1 scale 0.05 }
        finish {
            phong 0.5
            reflection 0.04
        }
    }
}

// ---------------- TOP SECTION ----------------
cone {
    <0, Height+3, 0>, Radius*3.2
    <0, Height+8, 0>, 0

    texture {
        pigment {
            granite
            color_map {
                [0.0 color rgb <0.10, 0.65, 0.30>] 
                [0.5 color rgb <0.15, 0.75, 0.40>] 
                [1.0 color rgb <0.20, 0.80, 0.50>] 
            }
            scale 0.1
        }
        normal { granite 0.1 scale 0.05 }
        finish {
            phong 0.55
            specular 0.1 
        }
    }
}

    translate <PosX,0,PosZ>
}

#end

// ---------------- FOREST ----------------

#declare SEED = seed(1234);

#local NumTrees = 60;
#local i = 0;

#while (i < NumTrees) 
    
    #local RandomX = -150 + rand(SEED) * 300;
    
    #local RandomZ = 10 + rand(SEED) * 240;

    #local H = 6 + rand(SEED)*4;
    #local R = 0.45 + rand(SEED)*0.35;

    RetroTree(
        RandomX,
        RandomZ,
        H,
        R
    )

    #local i = i + 1; 
#end

// ---------------- MOUNTAIN RANGE ----------------

#declare MOUNTAIN_SEED = seed(999);
#local MX = -400;

#while (MX < 400)
    
    #local MZ = 380 + rand(MOUNTAIN_SEED) * 40;
    #local MH = 50 + rand(MOUNTAIN_SEED) * 150; 
    #local MR = 60 + rand(MOUNTAIN_SEED) * 110; 

    union {
        // Main central peak
        cone {
            <0, -20, 0>, MR
            <0, MH, 0>, 0
            scale <1.5, 1, 1> 
        }
        
        // Jagged peak 1 (leaning left)
        cone {
            <0, -20, 0>, MR * 0.7
            <0, MH * 0.8, 0>, 0
            scale <1.2, 1, 1>
            rotate <0, 0, 12 + rand(MOUNTAIN_SEED)*15>
            translate <-MR * 0.5, 0, rand(MOUNTAIN_SEED)*20 - 10>
        }

        // Jagged peak 2 (leaning right)
        cone {
            <0, -20, 0>, MR * 0.6
            <0, MH * 0.7, 0>, 0
            scale <1.3, 1, 1>
            rotate <0, 0, -10 - rand(MOUNTAIN_SEED)*18>
            translate <MR * 0.6, 0, rand(MOUNTAIN_SEED)*20 - 10>
        }
        
        // Jagged peak 3 (leaning forward to break up the flat face)
        cone {
            <0, -20, 0>, MR * 0.5
            <0, MH * 0.6, 0>, 0
            scale <1.4, 1, 1>
            rotate <15 + rand(MOUNTAIN_SEED)*10, 0, 0>
            translate <0, 0, -MR * 0.3>
        }

        texture {
            pigment {
                gradient y
                color_map {
                    [0.0 color rgb <0.02, 0.05, 0.08>] // Dark base
                    [0.6 color rgb <0.08, 0.12, 0.20>] // Midtones
                    [1.0 color rgb <0.45, 0.55, 0.70>] // Faded snow caps
                }
                scale MH // Scale the gradient to match the mountain's height
            }
            normal {
                granite 0.5
                scale 25
            }
            finish {
                ambient 0.15
                diffuse 0.5
            }
        }
        
        translate <MX, 0, MZ>
    }
    
    #local MX = MX + 40 + rand(MOUNTAIN_SEED)*70; 
#end

// ---------------- BLUE SUN ----------------

sphere {
    < -150, 240, 500 >, 50

    texture {
        pigment {
            color rgb <0.3, 0.35, 0.4> // blue grey
        }
        finish {
            emission 0.8
        }
    }
}
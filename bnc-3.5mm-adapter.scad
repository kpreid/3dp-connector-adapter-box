main();


module main() {
    connector_adapter_box() {
        bnc_112420_neg();
        
        trs_neg();
    }
}


// Children are two hollows for connector
module connector_adapter_box() {
    difference() {
        minkowski() {
            cylinder(d=2, h=2, center=true, $fn=20);
            interior_volume() children();
        }
        
        interior_volume() children();

        cube([100, 100, 100]);
    }
    
    %union() {
            children(0);
            
            rotate([180, 0, 0])
            children(1);
    }
        
    module interior_volume() {
        hull() {
            children(0);
            
            rotate([180, 0, 0])
            children(1);
        }
    }
}


// Amphenol 112420 per https://www.amphenolrf.com/112420.html
module bnc_112420_neg() {
    thread_length = 8.8;
    solder_cup_length = 4.3;
    
    // thread clearance
    // TODO ensure tooth-biting fit
    cylinder(d=3/8 * 25.4, h=thread_length + solder_cup_length, $fn=30);
}

// LJE0352-4R per http://www.fk-industrie.de/downloads/LJE0352s.pdf
module trs_neg() {
    // thread area
    cylinder(d=8.1, h=3.5, $fn=30);
}
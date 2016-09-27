control p() {
    @name("z") bit<1> z_0;
    @name("x_0") bit<1> x_2;
    @name("x_1") bit<1> x_3;
    @name("y_0") bit<1> y_1;
    @name("b") action b_0(in bit<1> x, out bit<1> y) {
        bit<1> tmp;
        x_2 = x;
        tmp = x & x_2;
        z_0 = tmp;
    }
    bit<1> tmp_0;
    bit<1> tmp_1;
    apply {
        x_3 = 1w0;
        tmp_0 = x_3;
        b_0(tmp_0, tmp_1);
        y_1 = tmp_1;
    }
}

control simple();
package m(simple pipe);
.m(.p()) main;

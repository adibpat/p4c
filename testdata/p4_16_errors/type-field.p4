/*
Copyright 2016 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
#include <v1model.p4>

header d_t {
  bit<32> f;
}

struct h {
  d_t d;
}

struct m { }

parser MyParser(packet_in b,
                out h hdr,
                inout m meta,
                inout standard_metadata_t standard_metadata) {
  state start {
    b.extract(hdr.d);
    transition accept;
  }
}

control MyVerifyChecksum(in h hdr,
                       inout m meta) {
  apply {}

}
control MyIngress(inout h hdr,
                  inout m meta,
                  inout standard_metadata_t standard_metadata) {
  apply {}
}
control MyEgress(inout h hdr,
               inout m meta,
               inout standard_metadata_t standard_metadata) {
  apply {}
}

control MyComputeChecksum(inout h hdr,
                          inout m meta) {
  apply {}
}
control MyDeparser(packet_out b, in h hdr) {
  apply {
    b.emit(h.d);
  }
}

V1Switch(MyParser(),
         MyVerifyChecksum(),
         MyIngress(),
         MyEgress(),
         MyComputeChecksum(),
         MyDeparser()) main;

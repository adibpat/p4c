#include <core.p4>
#include <v1model.p4>

header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> ethertype;
}

struct metadata {
}

struct headers {
    @name(".ethernet") 
    ethernet_t ethernet;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name(".start") state start {
        packet.extract<ethernet_t>(hdr.ethernet);
        transition accept;
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name(".c1") counter(32w1024, CounterType.packets) c1;
    @name(".count_c1_1") action count_c1_1() {
        c1.count(32w1);
    }
    @name(".t1") table t1 {
        actions = {
            count_c1_1();
            @defaultonly NoAction();
        }
        key = {
            hdr.ethernet.dstAddr: exact @name("ethernet.dstAddr") ;
        }
        default_action = NoAction();
    }
    @name(".t2") table t2 {
        actions = {
            count_c1_1();
            @defaultonly NoAction();
        }
        key = {
            hdr.ethernet.srcAddr: exact @name("ethernet.srcAddr") ;
        }
        default_action = NoAction();
    }
    apply {
        t1.apply();
        t2.apply();
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit<ethernet_t>(hdr.ethernet);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

V1Switch<headers, metadata>(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;

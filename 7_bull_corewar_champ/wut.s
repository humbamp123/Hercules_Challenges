.name "confetti_warrior"
.comment "You'll never get rid of me!!"

test:
ld	%268435202, r9
st	r9, -40
ld	%2415919104, r5
st	r5, -48
ld	%34209770, r4
st	r4, -56
zjmp %:test
fork %20
st r1, 6
live %00



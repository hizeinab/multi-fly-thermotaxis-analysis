function mustBeEqualSize(a,b)
% Test for equal size
if ~isequal(size(a),size(b))
    eid = 'Size:notEqual';
    msg = 'Inputs must have equal size.';
    throwAsCaller(MException(eid,msg))
end
end
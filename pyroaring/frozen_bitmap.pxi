cdef croaring.roaring_bitmap_t *deserialize_frozen_ptr(const unsigned char[:] buff):
    cdef croaring.roaring_bitmap_t *ptr
    cdef const char *reason_failure = NULL

    buff_size = len(buff)
    ptr = <croaring.roaring_bitmap_t*>croaring.roaring_bitmap_frozen_view(<char*>&buff[0], buff_size)

    if ptr == NULL:
      raise ValueError("Could not deserialize bitmap")

    return ptr


cdef class FrozenBitMap(AbstractBitMap):

    @classmethod
    def deserialize_frozen_view(cls, const unsigned char[:] buff):
        """
        Generate a frozen view of the bitmap from the given bytes.

        This frozen view format is not portable or stable, and should only be used with
        the same version of croaring. The buffer being read is also not validated.
        However because this is close to a readonly view of the already existing data,
        this can be used to share memory across bitmaps with mmaps, and faster readonly
        operations with less deserialization overhead.

        Note also that this is a readonly view into the input buffer - the underlying
        buffer must be around for as long as this FrozenBitMap is.

        See pyroaring.ensure_frozen_aligned if you need to create a frozen_view on bytes
        objects that have been saved/restore, and not directly returned by
        AbstractBitMap.serialize_frozen_view.

        See AbstractBitMap.serialize_frozen_view for the reverse operation.

        >>> frozen = BitMap([3, 12]).serialize_frozen_view()

        The resulting type is a Cython array pointing at the correctly aligned memory.
        >>> frozen  # doctest: +ELLIPSIS
        <pyroaring.array object at ...>

        This can be serialised as bytes or other array objects - but will need to be
        aligned before use. The format is not stable or portable.
        >>> bytes(frozen)  # doctest: +ELLIPSIS
        b'...'

        frozen_views are fast to deserialize, but read-only, and the backing data needs
        to be kept around as long as you want to work the resulting FrozenBitMap
        >>> FrozenBitMap.deserialize_frozen_view(frozen)
        FrozenBitMap([3, 12])

        """
        # TODO: should a reference to buff be kept?
        return (<FrozenBitMap>cls()).from_ptr(deserialize_frozen_ptr(buff)) # FIXME to change when from_ptr is a classmethod


cdef class FrozenBitMap64(AbstractBitMap64):
    pass

# distutils: language = c++

import numpy as np
from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.map cimport map
from libcpp.string cimport string
from mbtr cimport MBTR

cdef class MBTRWrapper:
    cdef MBTR *thisptr      # hold a C++ instance which we're wrapping

    def __cinit__(self, map[int,int] atomic_number_to_index_map, int interaction_limit, vector[vector[int]] indices):
        self.thisptr = new MBTR(atomic_number_to_index_map, interaction_limit, indices)

    def __dealloc__(self):
        del self.thisptr

    def get_k1(self, Z, geom_func, weight_func, parameters, start, stop, sigma, n):
        """Cython cannot directly provide the keys as tuples, so we have to do
        the conversion here on the python side.
        """
        k1_map = self.thisptr.getK1(Z, geom_func, weight_func, parameters, start, stop, sigma, n)
        k1_map = dict(k1_map)
        new_k1_map = {}

        for key, value in k1_map.items():
            new_key = tuple([int(key.decode("utf-8"))])
            new_k1_map[new_key] = np.array(value, dtype=np.float32)

        return new_k1_map

    def get_k2(self, Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n):
        """Cython cannot directly provide the keys as tuples, so we have to do
        the conversion here on the python side.
        """
        k2_map = self.thisptr.getK2(Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n)
        k2_map = dict(k2_map)
        new_k2_map = {}

        for key, value in k2_map.items():
            new_key = tuple(int(x) for x in key.decode("utf-8").split(","))
            new_k2_map[new_key] = np.array(value, dtype=np.float32)

        return new_k2_map

    def get_k3(self, Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n):
        """Cython cannot directly provide the keys as tuples, so we have to do
        the conversion here on the python side.
        """
        k3_map = self.thisptr.getK3(Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n)
        k3_map = dict(k3_map)
        new_k3_map = {}

        for key, value in k3_map.items():
            new_key = tuple(int(x) for x in key.decode("utf-8").split(","))
            new_k3_map[new_key] = np.array(value, dtype=np.float32)

        return new_k3_map

    def get_k2_local(self, indices, Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n):
        """Cython cannot directly provide the keys as tuples, so we have to do
        the conversion here on the python side.
        """
        k2_list = self.thisptr.getK2Local(indices, Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n)
        new_k2_list = []

        for item in k2_list:
            new_k2_map = {}
            item = dict(item)
            for key, value in item.items():
                new_key = tuple(int(x) for x in key.decode("utf-8").split(","))
                new_k2_map[new_key] = np.array(value, dtype=np.float32)
            new_k2_list.append(new_k2_map)

        return new_k2_list

    def get_k3_local(self, indices, Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n):
        """Cython cannot directly provide the keys as tuples, so we have to do
        the conversion here on the python side.
        """
        k3_list = self.thisptr.getK3Local(indices, Z, distances, neighbours, geom_func, weight_func, parameters, start, stop, sigma, n)
        new_k3_list = []

        for item in k3_list:
            new_k3_map = {}
            item = dict(item)
            for key, value in item.items():
                new_key = tuple(int(x) for x in key.decode("utf-8").split(","))
                new_k3_map[new_key] = np.array(value, dtype=np.float32)
            new_k3_list.append(new_k3_map)

        return new_k3_list

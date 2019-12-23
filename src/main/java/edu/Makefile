GCC=g++
NVCC?=nvcc
OUT_DIR=bin

EXECS= breaking_rsa \
	   breaking_rsa_GPU

all: directories ${EXECS}

directories: ${OUT_DIR}

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

breaking_rsa: breaking_rsa.cpp
	${GCC} -o ${OUT_DIR}/breaking_rsa breaking_rsa.cpp

breaking_rsa_GPU: breaking_rsa_GPU.cu
	${NVCC} -o ${OUT_DIR}/breaking_rsa_GPU breaking_rsa_GPU.cu

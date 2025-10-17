{
	gSystem->Load("libsqlite3.so");
	gSystem->Load("libfftw3.so");
	gSystem->Load("libgsl.so");
	gSystem->Load("libMathMore.so");
	gSystem->Load("libGeom.so");
	gSystem->Load("libGraf3d.so");
	gSystem->Load("libPhysics.so");
	gSystem->Load("libRootFftwWrapper.so");
	gSystem->Load("libAraEvent.so");
	gSystem->Load("libAraConfig.so");
	gSystem->Load("libAraDisplay.so");
	gSystem->Load("libAraCorrelator.so");
	gSystem->Load("libAraVertex.so");
	gSystem->AddIncludePath("-I${ARA_UTIL_INSTALL_DIR}/include");
	gSystem->AddIncludePath("-I${ARA_UTIL_INSTALL_DIR}/lib");
	gSystem->AddIncludePath("-I${ARA_DEPS_INSTALL_DIR}/include");
        gSystem->AddIncludePath("-I${ARA_DEPS_INSTALL_DIR}/lib");
	gSystem->AddIncludePath("-I FFTtools.h");
	gROOT->ProcessLine("#include <FFTtools.h>");

}

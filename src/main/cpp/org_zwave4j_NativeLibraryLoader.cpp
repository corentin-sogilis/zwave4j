#include <Manager.h>
#include <org_zwave4j_NativeLibraryLoader.h>
#include "init.h"

/*
 * Class:     org_zwave4j_NativeLibraryLoader
 * Method:    getOpenZWaveVersion
 * Signature: (J)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_org_zwave4j_NativeLibraryLoader_getOpenZWaveVersion
  (JNIEnv * env, jclass clazz)
{
    return env->NewStringUTF(("OpenZWave version: " + OpenZWave::Manager::Get()->getVersionAsString()).c_str());
}

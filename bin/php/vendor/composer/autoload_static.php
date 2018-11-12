<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit6b1dd25da5d8c7ddf081c424eceadc72
{
    public static $prefixLengthsPsr4 = array (
        'S' => 
        array (
            'Seld\\JsonLint\\' => 14,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Seld\\JsonLint\\' => 
        array (
            0 => __DIR__ . '/..' . '/seld/jsonlint/src/Seld/JsonLint',
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit6b1dd25da5d8c7ddf081c424eceadc72::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit6b1dd25da5d8c7ddf081c424eceadc72::$prefixDirsPsr4;

        }, null, ClassLoader::class);
    }
}

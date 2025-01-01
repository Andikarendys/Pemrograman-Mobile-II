<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});


$router->group(['prefix' => 'barang'], function () use ($router) {
    $router->get('/', 'barangcontroller@read');
    $router->post('/simpan', 'barangcontroller@add');
    $router->put('/ubah/{id}', 'barangcontroller@update');
    $router->delete('/hapus/{id}', 'barangcontroller@delete');
});


$router->group(['prefix' => 'pelanggan'], function () use ($router) {
    $router->get('/', 'PelangganController@index');
    $router->post('/simpan', 'PelangganController@simpan');
    $router->put('/ubah/{id}', 'PelangganController@ubah');
    $router->delete('/hapus/{id}', 'PelangganController@hapus');
});


$router->group(['prefix' => 'transaksi'], function () use ($router) {
    $router->get('/', 'TransaksiController@index');
    $router->post('/simpan', 'TransaksiController@simpan');
    $router->put('/ubah/{id}', 'TransaksiController@ubah');
    $router->delete('/hapus/{id}', 'TransaksiController@hapus');
});

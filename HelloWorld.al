// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.ProjectTransmitter;

using Microsoft.Sales.Customer;

pageextension 50200 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Message('ProjectTransmitter er loaded!');
    end;
}